<% @sun.role_recipes(%W(
  bootstrap/all
  user/deployer
  db/sqlite
  db/postgres__POSTGRES__
  nginx/passenger
  nginx/htpasswd
  nginx/logrotate
  ssl/ca
  ssl/nginx
  ruby/system__APT_RUBY__
  utils/all
  ruby/app__RBENV_RUBY__
)) do |name, id| %>

  sun.source_recipe "<%= name %>" <%= id %>

<% end %>
