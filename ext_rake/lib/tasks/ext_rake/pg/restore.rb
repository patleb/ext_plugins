module ExtRake
  class PgRestore < Pg
    def self.steps
      [:pg_restore]
    end

    def self.args
      {
        name:     ['--name=NAME',         'Dump name (default to dump)'],
        includes: ['--includes=INCLUDES', 'Included tables'],
      }
    end

    def self.ignored_errors
      [
        'ERROR:  must be owner of extension plpgsql',
      ]
    end

    def self.sanitized_lines
      {
        pg_password: /PGPASSWORD=\w+;/,
        pg_restore: /pg_restore.+\//,
      }
    end

    def pg_restore
      with_config do |host, db, user, pwd|
        if options.includes.present?
          only = options.includes.split(',').reject(&:blank?).map{ |table| "--table='#{table}'" }.join(' ')
        end
        name = options.name.presence || 'dump'
        cmd = <<~CMD
          export PGPASSWORD=#{pwd};
          pg_restore --verbose --host #{host} --username #{user} #{self.class.pg_options} --no-owner --no-acl #{only} --dbname #{db} #{ExtRake.config.rails_root}/db/#{name}.pg
        CMD
        _stdout, stderr, _status = Open3.capture3(cmd)
        notify!(cmd, stderr) if notify?(stderr)
      end
    end
  end
end