require 'ext_capistrano'
require 'sun_cap/capistrano'
require_rel '../capistrano/tasks/ext_capistrano/helpers/**/*.rb'
load 'capistrano/tasks/ext_capistrano.rake'
load_rel '../capistrano/tasks/ext_capistrano/**/*.rake'
