# https://mmonit.com/monit/documentation/monit.html
# https://linux.die.net/man/1/monit
# https://bitbucket.org/tildeslash/monit/

namespace :monit do
  desc 'Export monit configuration file'
  task :push do
    on release_roles :all do
      invoke! 'template:push', 'monitrc', '/etc/monit/monitrc'
      execute :sudo, 'chown root:root /etc/monit/monitrc'
      execute :sudo, 'chmod 0700 /etc/monit/monitrc'
    end
  end

  %w[start stop restart].each do |action|
    desc "#{action.capitalize} monit"
    task action do
      on release_roles :all do
        execute :sudo, "service monit #{action} all"
      end
    end
  end

  desc 'Reload monit'
  task :reload do
    on release_roles :all do
      execute :sudo, 'service monit reload'
    end
  end

  # TODO similar check for AWS Cloudwatch
  desc 'Check mail users'
  task :check_mail_users do
    on release_roles :all do
      SettingsYml[:mail_to].each do |mail_to|
        unless test :sudo, "cat /etc/monit/monitrc | grep 'set alert #{mail_to} not on'"
          invoke 'monit:push'
          invoke 'monit:reload'
          break
        end
      end
    end
  end
  after 'deploy:publishing', 'monit:check_mail_users'
end
