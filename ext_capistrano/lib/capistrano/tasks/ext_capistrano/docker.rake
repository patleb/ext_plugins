# TODO https://github.com/capistrano/sshkit/pull/368
# TODO https://github.com/moby/moby/issues/14856
# TODO https://stackoverflow.com/questions/42510002/how-to-clear-properly-the-logs-of-docker-container

namespace :docker do
  desc 'Export Dockerfile template'
  task :push, [:template] do |t, args|
    on release_roles fetch(:docker_roles) do
      template = args[:template].presence || 'Dockerfile'
      execute :mkdir, '-p', release_path.join(fetch(:docker_dir))
      invoke! 'template:push', template, release_path.join(fetch(:docker_dir), File.basename(template))
    end
  end

  namespace :compose do
    desc 'Export docker-compose.yml template'
    task :push, [:template] do |t, args|
      on release_roles fetch(:docker_roles) do
        template = args[:template].presence || 'docker-compose.yml'
        execute :mkdir, '-p', release_path.join(fetch(:docker_dir))
        invoke! 'template:push', template, release_path.join(fetch(:docker_dir), File.basename(template))
      end
    end

    desc 'Start docker services'
    task :up, [:options] do |t, args|
      on release_roles fetch(:docker_roles) do
        execute "cd #{release_path.join(fetch(:docker_dir))}; docker-compose up -d #{args[:options]}"
      end
    end
    after 'deploy:app:push', 'docker:compose:up'

    desc 'Build docker images'
    task :build, [:options] do |t, args|
      on release_roles fetch(:docker_roles) do
        execute "cd #{release_path.join(fetch(:docker_dir))}; docker-compose build #{args[:options]}"
      end
    end

    desc 'Restart service(s)'
    task :restart, [:options] do |t, args|
      on release_roles fetch(:docker_roles) do
        execute "cd #{release_path.join(fetch(:docker_dir))}; docker-compose restart #{args[:options]}" unless ENV['SKIP_DOCKER_RESTART'].to_b
      end
    end
    after 'deploy:publishing', 'docker:compose:restart'

    desc 'Skip docker-compose restart'
    task :skip_restart do
      on release_roles fetch(:docker_roles) do
        ENV['SKIP_DOCKER_RESTART'] = 'true'
      end
    end
    before 'deploy:app:push', 'docker:compose:skip_restart'
  end
end
