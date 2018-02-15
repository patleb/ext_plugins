require "require_all"
require 'rubygems/package'
require 'colorize'
require 'dotiw'
require 'open3'
require 'optparse'
require 'ext_aws_sdk'
require "ext_mail"
require "ext_rake/configuration"
require 'ext_rake/railtie' if defined?(Rails)

module ActiveTask
  autoload :Base, 'ext_rake/active_task/base'
end

module ExtRake
  autoload :Backup,    'tasks/ext_rake/backup'
  autoload :Openvpn,   'tasks/ext_rake/openvpn'
  autoload :Partition, 'tasks/ext_rake/partition'
  autoload :Pgslice,   'tasks/ext_rake/pgslice'
  autoload :Psql,      'tasks/ext_rake/psql'
  autoload :Restore,   'tasks/ext_rake/restore'

  autoload :PartitionBackup,  'tasks/ext_rake/backups/partition'

  autoload :ArchiveRestore,   'tasks/ext_rake/restores/archive'
  autoload :PostgresRestore,  'tasks/ext_rake/restores/postgres'
  autoload :SyncRestore,      'tasks/ext_rake/restores/sync'

  autoload :BackupGit,          'tasks/ext_rake/addons/backup_git'
  autoload :CleanUpApplication, 'tasks/ext_rake/addons/clean_up_application'
  autoload :SendMail,           'tasks/ext_rake/addons/send_mail'
  autoload :UpdateApplication,  'tasks/ext_rake/addons/update_application'
  autoload :UpdateVpnIp,        'tasks/ext_rake/addons/update_vpn_ip'
end
