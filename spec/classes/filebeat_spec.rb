require 'spec_helper'

describe 'filebeat', :type => :class do
  let :facts do
    {
      :osfamily => 'Debian',
      :lsbdistid => 'Ubuntu',
      :puppetversion => ENV['PUPPET_GEM_VERSION'],
    }
  end

  context 'defaults' do
    it { is_expected.to contain_filebeat__params }
    it { is_expected.to contain_package('filebeat') }
    it { is_expected.to contain_file('filebeat.yml').with(
      :path => '/etc/filebeat/filebeat.yml',
      :mode => '0644',
    )}
    it { is_expected.to contain_file('filebeat-config-dir').with(
      :ensure => 'directory',
      :path   => '/etc/filebeat/conf.d',
      :mode   => '0755',
      :recurse => true,
    )}
    it { is_expected.to contain_service('filebeat').with(
      :enable => true,
      :ensure => 'running',
    )}
    it { is_expected.to contain_apt__source('filebeat').with(
      :location => 'http://packages.elastic.co/beats/apt',
      :key      => {
        'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
        'source' => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
      }
    )}

  end

  describe 'on a RHEL system' do
    let :facts do
      {
        :osfamily => 'RedHat',
        :puppetversion => ENV['PUPPET_GEM_VERSION'],
      }
    end

    it { is_expected.to contain_yumrepo('filebeat').with(
      :baseurl => 'https://packages.elastic.co/beats/yum/el/$basearch',
      :gpgkey  => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
    ) }
  end

  describe 'on a Solaris system' do
    let :facts do
      {
        :osfamily => 'Solaris',
      }
    end
    context 'it should fail as unsupported' do
      it { expect { should raise_error(Puppet::Error) } }
    end
  end
end
