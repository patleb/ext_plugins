RUBY_VERSION=<%= "=#{@sun.apt_ruby}" if @sun.apt_ruby %>
RUBY_MANIFEST=$(sun.manifest_path 'ruby')

if [[ ! -s "$RUBY_MANIFEST" ]]; then
  sun.install "ruby-full$RUBY_VERSION"
  apt-mark hold ruby-full

  echo 'gem: --no-ri --no-rdoc' > ~/.gemrc

  gem install bundler
else
  sun.update

  declare -a gem_names=($(gem list | cut -d ' ' -f 1))
  declare -a gem_versions=($(gem list | cut -d ' ' -f 2 | sed -r 's/(^\(|\)$|,$)//g'))

  apt-mark unhold ruby-full
  sun.install "ruby-full$RUBY_VERSION"
  apt-mark hold ruby-full

  for i in "${!gem_names[@]}"; do
    gem install "${gem_names[$i]}" -v "${gem_versions[$i]}" --ignore-dependencies
  done
fi

echo "$RUBY_VERSION" >> "$RUBY_MANIFEST"
