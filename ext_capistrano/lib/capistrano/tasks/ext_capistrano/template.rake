namespace :template do
  task :compile, [:name] do |t, args|
    on release_roles :all do
      compile_erb "config/deploy/templates/#{args[:name]}"
    end
  end

  task :push, [:name, :host_path] do |t, args|
    on release_roles :all do |host|
      raise 'host destination must be specified' unless args[:host_path].present?
      upload_erb host, "config/deploy/templates/#{args[:name]}", args[:host_path]
    end
  end
end
