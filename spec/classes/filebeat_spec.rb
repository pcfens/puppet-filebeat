require 'spec_helper'

describe 'filebeat', type: :class do
  context 'on a system with filebeat 1.x already installed' do
    let :facts do
      {
        kernel: 'Linux',
        osfamily: 'Debian',
        lsbdistid: 'Ubuntu',
        lsbdistrelease: '16.04',
        rubyversion: '1.9.3',
        puppetversion: Puppet.version,
        filebeat_version: '1.3.1'
      }
    end

    context 'defaults' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('filebeat') }
      it { is_expected.to contain_class('filebeat::params') }
      it { is_expected.to contain_anchor('filebeat::begin') }
      it { is_expected.to contain_anchor('filebeat::end') }
      it { is_expected.to contain_class('filebeat::install') }
      it { is_expected.to contain_class('filebeat::config') }
      it { is_expected.to contain_anchor('filebeat::install::begin') }
      it { is_expected.to contain_anchor('filebeat::install::end') }
      it { is_expected.to contain_class('filebeat::install::linux') }
      it { is_expected.to contain_class('filebeat::repo') }
      it { is_expected.to contain_class('filebeat::service') }
      it { is_expected.not_to contain_class('filebeat::install::windows') }
      it do
        is_expected.to contain_file('filebeat.yml').with(
          path: '/etc/filebeat/filebeat.yml',
          mode: '0644'
        )
      end
      it do
        is_expected.to contain_file('filebeat-config-dir').with(
          ensure: 'directory',
          path: '/etc/filebeat/conf.d',
          mode: '0755',
          recurse: true
        )
      end
      it do
        is_expected.to contain_service('filebeat').with(
          enable: true,
          ensure: 'running',
          provider: nil
        )
      end
      it do
        is_expected.to contain_apt__source('beats').with(
          location: 'http://packages.elastic.co/beats/apt',
          key: {
            'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
            'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
          }
        )
      end
    end

    describe 'on a RHEL system' do
      let :facts do
        {
          kernel: 'Linux',
          osfamily: 'RedHat',
          rubyversion: '1.8.7',
          puppetversion: Puppet.version,
          filebeat_version: '1.3.1'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('filebeat::params') }
      it { is_expected.to contain_anchor('filebeat::begin') }
      it { is_expected.to contain_anchor('filebeat::end') }
      it { is_expected.to contain_class('filebeat::install') }
      it { is_expected.to contain_class('filebeat::config') }
      it { is_expected.to contain_anchor('filebeat::install::begin') }
      it { is_expected.to contain_anchor('filebeat::install::end') }

      it do
        is_expected.to contain_yumrepo('beats').with(
          baseurl: 'https://packages.elastic.co/beats/yum/el/$basearch',
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
      end

      it do
        is_expected.to contain_service('filebeat').with(
          enable: true,
          ensure: 'running',
          provider: 'redhat'
        )
      end
    end

    describe 'on a Windows system' do
      let :facts do
        {
          kernel: 'Windows',
          rubyversion: '1.9.3',
          puppetversion: Puppet.version,
          filebeat_version: '1.3.1'
        }
      end

      # it { is_expected.to compile.with_all_deps } # Omitted because of https://github.com/rodjek/rspec-puppet/issues/192
      it { is_expected.to contain_class('filebeat::params') }
      it { is_expected.to contain_anchor('filebeat::begin') }
      it { is_expected.to contain_anchor('filebeat::end') }
      it { is_expected.to contain_class('filebeat::install') }
      it { is_expected.to contain_class('filebeat::config') }
      it { is_expected.to contain_anchor('filebeat::install::begin') }
      it { is_expected.to contain_anchor('filebeat::install::end') }

      it { is_expected.to contain_class('filebeat::install::windows') }
      it { is_expected.not_to contain_class('filebeat::install::linux') }
      it { is_expected.to contain_file('filebeat.yml').with_path('C:/Program Files/Filebeat/filebeat.yml') }
      it do
        is_expected.to contain_file('filebeat-config-dir').with(
          ensure: 'directory',
          path: 'C:/Program Files/Filebeat/conf.d',
          recurse: true
        )
      end
      it do
        is_expected.to contain_service('filebeat').with(
          enable: true,
          ensure: 'running',
          provider: nil
        )
      end
    end
  end

  [
    nil,
    '5.1.1'
  ].each do |filebeat_vers|
    context "on a system with filebeat #{filebeat_vers} installed" do
      let :facts do
        {
          kernel: 'Linux',
          osfamily: 'Debian',
          lsbdistid: 'Ubuntu',
          lsbdistrelease: '16.04',
          rubyversion: '1.9.3',
          puppetversion: Puppet.version,
          filebeat_version: filebeat_vers
        }
      end

      context 'defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('filebeat') }
        it { is_expected.to contain_class('filebeat::params') }
        it { is_expected.to contain_anchor('filebeat::begin') }
        it { is_expected.to contain_anchor('filebeat::end') }
        it { is_expected.to contain_class('filebeat::install') }
        it { is_expected.to contain_class('filebeat::config') }
        it { is_expected.to contain_anchor('filebeat::install::begin') }
        it { is_expected.to contain_anchor('filebeat::install::end') }
        it { is_expected.to contain_class('filebeat::install::linux') }
        it { is_expected.to contain_class('filebeat::repo') }
        it { is_expected.to contain_class('filebeat::service') }
        it { is_expected.not_to contain_class('filebeat::install::windows') }
        it do
          is_expected.to contain_file('filebeat.yml').with(
            path: '/etc/filebeat/filebeat.yml',
            mode: '0644'
          )
        end
        it do
          is_expected.to contain_file('filebeat-config-dir').with(
            ensure: 'directory',
            path: '/etc/filebeat/conf.d',
            mode: '0755',
            recurse: true
          )
        end
        it do
          is_expected.to contain_service('filebeat').with(
            enable: true,
            ensure: 'running',
            provider: nil
          )
        end
        it do
          is_expected.to contain_apt__source('beats').with(
            location: 'https://artifacts.elastic.co/packages/5.x/apt',
            key: {
              'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
              'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
            }
          )
        end
      end

      describe 'on a RHEL system' do
        let :facts do
          {
            kernel: 'Linux',
            osfamily: 'RedHat',
            rubyversion: '1.8.7',
            puppetversion: Puppet.version,
            filebeat_version: filebeat_vers
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('filebeat::params') }
        it { is_expected.to contain_anchor('filebeat::begin') }
        it { is_expected.to contain_anchor('filebeat::end') }
        it { is_expected.to contain_class('filebeat::install') }
        it { is_expected.to contain_class('filebeat::config') }
        it { is_expected.to contain_anchor('filebeat::install::begin') }
        it { is_expected.to contain_anchor('filebeat::install::end') }

        it do
          is_expected.to contain_yumrepo('beats').with(
            baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
            gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
          )
        end

        it do
          is_expected.to contain_service('filebeat').with(
            enable: true,
            ensure: 'running',
            provider: 'redhat'
          )
        end
      end

      describe 'on a Windows system' do
        let :facts do
          {
            kernel: 'Windows',
            rubyversion: '1.9.3',
            puppetversion: Puppet.version,
            filebeat_version: filebeat_vers
          }
        end

        # it { is_expected.to compile.with_all_deps } # Omitted because of https://github.com/rodjek/rspec-puppet/issues/192
        it { is_expected.to contain_class('filebeat::params') }
        it { is_expected.to contain_anchor('filebeat::begin') }
        it { is_expected.to contain_anchor('filebeat::end') }
        it { is_expected.to contain_class('filebeat::install') }
        it { is_expected.to contain_class('filebeat::config') }
        it { is_expected.to contain_anchor('filebeat::install::begin') }
        it { is_expected.to contain_anchor('filebeat::install::end') }

        it { is_expected.to contain_class('filebeat::install::windows') }
        it { is_expected.not_to contain_class('filebeat::install::linux') }
        it { is_expected.to contain_file('filebeat.yml').with_path('C:/Program Files/Filebeat/filebeat.yml') }
        it do
          is_expected.to contain_file('filebeat-config-dir').with(
            ensure: 'directory',
            path: 'C:/Program Files/Filebeat/conf.d',
            recurse: true
          )
        end
        it do
          is_expected.to contain_service('filebeat').with(
            enable: true,
            ensure: 'running',
            provider: nil
          )
        end
      end
    end
  end

  context 'when uninstalling filebeat' do
    let :facts do
      {
        kernel: 'Linux',
        osfamily: 'Debian',
        lsbdistid: 'Ubuntu',
        lsbdistrelease: '16.04',
        rubyversion: '1.9.3',
        puppetversion: Puppet.version,
        filebeat_version: '5.2.2'
      }
    end

    let :params do
      {
        package_ensure: 'absent'
      }
    end

    context 'defaults' do
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('filebeat') }
      it { is_expected.to contain_class('filebeat::params') }
      it { is_expected.to contain_anchor('filebeat::begin') }
      it { is_expected.to contain_anchor('filebeat::end') }
      it { is_expected.to contain_class('filebeat::install') }
      it { is_expected.to contain_class('filebeat::config') }
      it { is_expected.to contain_anchor('filebeat::install::begin') }
      it { is_expected.to contain_anchor('filebeat::install::end') }
      it { is_expected.to contain_class('filebeat::install::linux') }
      it { is_expected.to contain_class('filebeat::repo') }
      it { is_expected.to contain_class('filebeat::service') }
      it { is_expected.not_to contain_class('filebeat::install::windows') }
      it do
        is_expected.to contain_file('filebeat.yml').with(
          ensure: 'absent',
          path: '/etc/filebeat/filebeat.yml',
          mode: '0644'
        )
      end
      it do
        is_expected.to contain_file('filebeat-config-dir').with(
          ensure: 'absent',
          path: '/etc/filebeat/conf.d',
          mode: '0755',
          recurse: true
        )
      end
      it do
        is_expected.to contain_service('filebeat').with(
          ensure: 'stopped',
          provider: nil
        )
      end
      it do
        is_expected.to contain_apt__source('beats').with(
          ensure: 'absent',
          location: 'https://artifacts.elastic.co/packages/5.x/apt',
          key: {
            'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
            'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
          }
        )
      end
    end

    describe 'on a RHEL system' do
      let :facts do
        {
          kernel: 'Linux',
          osfamily: 'RedHat',
          rubyversion: '1.8.7',
          puppetversion: Puppet.version,
          filebeat_version: '5.2.2'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('filebeat::params') }
      it { is_expected.to contain_anchor('filebeat::begin') }
      it { is_expected.to contain_anchor('filebeat::end') }
      it { is_expected.to contain_class('filebeat::install') }
      it { is_expected.to contain_class('filebeat::config') }
      it { is_expected.to contain_anchor('filebeat::install::begin') }
      it { is_expected.to contain_anchor('filebeat::install::end') }

      it do
        is_expected.to contain_yumrepo('beats').with(
          ensure: 'absent',
          baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
          gpgkey: 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
        )
      end

      it do
        is_expected.to contain_service('filebeat').with(
          ensure: 'stopped',
          provider: 'redhat'
        )
      end
    end

    describe 'on a Windows system' do
      let :facts do
        {
          kernel: 'Windows',
          rubyversion: '1.9.3',
          puppetversion: Puppet.version,
          filebeat_version: '5.2.2'
        }
      end

      # it { is_expected.to compile.with_all_deps } # Omitted because of https://github.com/rodjek/rspec-puppet/issues/192
      it { is_expected.to contain_class('filebeat::params') }
      it { is_expected.to contain_anchor('filebeat::begin') }
      it { is_expected.to contain_anchor('filebeat::end') }
      it { is_expected.to contain_class('filebeat::install') }
      it { is_expected.to contain_class('filebeat::config') }
      it { is_expected.to contain_anchor('filebeat::install::begin') }
      it { is_expected.to contain_anchor('filebeat::install::end') }

      it { is_expected.to contain_class('filebeat::install::windows') }
      it { is_expected.not_to contain_class('filebeat::install::linux') }
      it { is_expected.to contain_file('filebeat.yml').with_path('C:/Program Files/Filebeat/filebeat.yml') }
      it do
        is_expected.to contain_file('filebeat-config-dir').with(
          ensure: 'absent',
          path: 'C:/Program Files/Filebeat/conf.d',
          recurse: true
        )
      end
      it do
        is_expected.to contain_service('filebeat').with(
          ensure: 'stopped',
          provider: nil
        )
      end
    end
  end

  describe 'on a Solaris system' do
    let :facts do
      {
        osfamily: 'Solaris'
      }
    end

    it { is_expected.to raise_error(Puppet::Error) }
  end
end
