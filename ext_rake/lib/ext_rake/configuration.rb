require 'settings_yml'

module ExtRake
  @@config = nil

  def self.configure
    @@config ||= Configuration.new

    if block_given?
      yield config
    end

    config
  end

  def self.config
    @@config || configure
  end

  class Configuration
    attr_writer :parent_task, :env_vars
    attr_writer :archive, :s3_versionned, :db

    def parent_task
      @parent_task ||= '::ActiveTask::Base'
    end

    def env_vars
      @env_vars ||= []
    end

    def rails_env
      ENV['RAILS_ENV'] || Rails.env
    end

    def rails_app
      ENV['RAILS_APP'] || Rails.application.engine_name.sub(/_application$/, '')
    end

    def rails_root
      Pathname.new(ENV['RAILS_ROOT'] || Rails.root || '').expand_path
    end

    def s3_access_key_id
      SettingsYml[:s3_access_key_id] || SettingsYml[:aws_access_key_id]
    end

    def s3_secret_access_key
      SettingsYml[:s3_secret_access_key] || SettingsYml[:aws_secret_access_key]
    end

    def s3_region
      SettingsYml[:s3_region] || SettingsYml[:aws_region]
    end

    def s3_bucket
      if s3_versionned?
        "#{SettingsYml[:s3_bucket]}-version"
      else
        SettingsYml[:s3_bucket]
      end
    end

    def s3_versionned?
      @s3_versionned || ENV['S3_VERSIONNED'].to_b
    end

    def db_adapter
      case db
      when 'server'
        ServerRecord
      else
        ActiveRecord::Base
      end
    end

    def db_url
      db = db_config
      "postgresql://#{db[:username]}:#{db[:password]}@#{db[:host]}:5432/#{db[:database]}"
    end

    def db_config
      case db
      when 'server'
        {
          host: '127.0.0.1',
          database: "server_#{SettingsYml[:db_database]}",
          username: SettingsYml[:db_username],
          password: SettingsYml[:db_password],
        }
      else
        {
          host: SettingsYml[:db_host],
          database: SettingsYml[:db_database],
          username: SettingsYml[:db_username],
          password: SettingsYml[:db_password],
        }
      end
    end

    def db
      @db || ENV['DB']
    end

    def shared_dir
      case rails_env.to_s
      when 'development', 'test'
        rails_root
      else
        rails_root.join('..', '..', 'shared').expand_path
      end
    end

    def log_dir
      shared_dir.join('log')
    end

    def backup_dir
      shared_dir.join('tmp', 'backups')
    end

    def backup_meta_file(model)
      backup_meta_dir.join(model, "#{remote? ? 'S3' : 'Local'}.yml")
    end

    def backup_meta_dir
      backup_dir.join('.data')
    end

    def backup_s3_path
      File.join('backups', backup_identifier)
    end

    def backup_local_path
      backup_dir.join(backup_identifier)
    end

    def backup_identifier
      "#{rails_app}_#{rails_env}"
    end

    def backup_model
      ENV['MODEL']
    end

    def backup_partition
      ENV['PARTITION']
    end

    def storage
      if remote?
        ::Backup::Storage::S3
      else
        ::Backup::Storage::Local
      end
    end

    def syncer
      if remote?
        ::Backup::Syncer::Cloud::S3
      else
        ::Backup::Syncer::RSync::Local
      end
    end

    def archive
      @archive || :data
    end

    def remote?
      SettingsYml[:backup_storage] == 's3'
    end
  end
end
