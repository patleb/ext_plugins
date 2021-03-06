$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require_relative "./../version"
version = ExtPlugins::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ext_coffee"
  s.version     = version
  s.authors     = ["Patrice Lebel"]
  s.email       = ["patleb@users.noreply.github.com"]
  s.homepage    = "https://github.com/patleb/ext_coffee"
  s.summary     = "ExtCoffee"
  s.description = "ExtCoffee"
  s.license     = "MIT"

  s.files = Dir["{app,lib,vendor}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "railties", "~> #{ExtPlugins::VERSION::RAILS_MAJOR}.#{ExtPlugins::VERSION::RAILS_MINOR}"
  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'uglifier', '>= 1.3.0'
  s.add_dependency 'alaska', '>= 1.2.2'
  s.add_dependency 'ext_ruby'
  s.add_dependency 'ext_sprockets'
  # TODO https://github.com/sfcgeorge/capybara-jsdom
  # https://github.com/GoogleChrome/puppeteer
end
