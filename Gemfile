source ENV['GEM_SOURCE'] || "https://rubygems.org"

# def location_for(place, fake_version = nil)
#   if place =~ /^(git:[^#]*)#(.*)/
#     [fake_version, { :git => $1, :branch => $2, :require => false }].compact
#   elsif place =~ /^file:\/\/(.*)/
#     ['>= 0', { :path => File.expand_path($1), :require => false }]
#   else
#     [place, { :require => false }]
#   end
# end

group :development, :unit_tests do
  gem 'rspec-core', '3.1.7',     :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'simplecov',               :require => false
  gem 'puppet_facts',            :require => false
  gem 'json',                    :require => false
  gem 'metadata-json-lint',      :require => false
  gem 'beaker-rspec',            :require => false
  gem 'pry',                     :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
