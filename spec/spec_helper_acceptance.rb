require 'beaker-rspec'
require 'pry'

hosts.each do |host|
  # Install Puppet
  on host, install_puppet
end

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => module_root, :module_name => 'filebeat',
                          :target_module_path => '/etc/puppet/modules')
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-apt'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-powershell'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','lwf-remote_file'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
