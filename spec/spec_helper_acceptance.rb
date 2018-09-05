require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ %r{pe}i
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation
  hosts.each do |host|
    if host[:platform] =~ %r{el-7-x86_64} && host[:hypervisor] =~ %r{docker}
      on(host, "sed -i '/nodocs/d' /etc/yum.conf")
    end
    install_module_from_forge('puppet-puppetserver', '>= 3.0.0 < 4.0.0')
    install_module_from_forge('puppetlabs-inifile', '>= 2.3.0 < 3.0.0')
    install_module_from_forge('puppetlabs-puppetserver_gem', '>= 1.0.0 < 2.0.0')
  end
end
