SettingsYml.clean(env: @environment)

deployer = Dir.pwd.match(/home\/(\w+)\//)[1]
context = %{export PATH="/home/#{deployer}/.rbenv/bin:/home/#{deployer}/.rbenv/plugins/ruby-build/bin:$PATH"; eval "$(rbenv init -)"; cd :path && :environment_variable=:environment}

set :output, "#{Whenever.path}/log/cron.log"
job_type :rake, "#{context} nice -n 19 :bundle_command rake :task --silent :output"
job_type :bash, "#{context} flock -n /run/lock/:task.lock bash -e -u bin/:task :output"