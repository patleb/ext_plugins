$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "./../version"
version = ExtPlugins::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ext_capistrano"
  s.version     = version
  s.authors     = ["Patrice Lebel"]
  s.email       = ["patleb@users.noreply.github.com"]
  s.homepage    = "https://github.com/patleb/ext_capistrano"
  s.summary     = "ExtCapistrano"
  s.description = "ExtCapistrano"
  s.license     = "MIT"

  s.files = Dir["{config,lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "capistrano", "~> 3.6"
  s.add_dependency 'capistrano-rbenv', '~> 2.0'
  s.add_dependency 'capistrano-bundler', '~> 1.1'
  s.add_dependency 'capistrano-rails', '~> 1.1'
  s.add_dependency 'capistrano-rails-console'
  s.add_dependency 'capistrano-passenger'
  s.add_dependency 'sun_cap', version
  s.add_dependency 'settings_yml'

  s.add_development_dependency "rake"
end
