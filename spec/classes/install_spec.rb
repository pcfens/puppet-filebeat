require 'spec_helper'

describe 'filebeat::install' do
  let :pre_condition do
    'include ::filebeat'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os_facts[:kernel] != 'windows'
        it { is_expected.to compile }
      end

      case os_facts[:kernel]
      when 'Linux'
        it { is_expected.to contain_class('filebeat::install::linux') }
        it { is_expected.to contain_class('filebeat::repo') } unless os_facts[:os]['family'] == 'Archlinux'
        it { is_expected.not_to contain_class('filebeat::install::windows') }

        # Test that the install class is properly contained
        it { is_expected.to contain_class('filebeat::install::linux').that_notifies('Class[filebeat::service]') }

        # Test ordering when manage_repo is true
        unless os_facts[:os]['family'] == 'Archlinux'
          it { is_expected.to contain_class('filebeat::repo').that_comes_before('Class[filebeat::install::linux]') }
        end

      when 'Windows'
        it { is_expected.to contain_class('filebeat::install::windows') }
        it { is_expected.not_to contain_class('filebeat::install::linux') }

        # Test that the install class is properly contained
        it { is_expected.to contain_class('filebeat::install::windows').that_notifies('Class[filebeat::service]') }

      when 'SunOS'
        it { is_expected.to contain_class('filebeat::install::sunos') }
        it { is_expected.to contain_class('filebeat::install::sunos').that_notifies('Class[filebeat::service]') }

      when 'FreeBSD'
        it { is_expected.to contain_class('filebeat::install::freebsd') }
        it { is_expected.to contain_class('filebeat::install::freebsd').that_notifies('Class[filebeat::service]') }

      when 'OpenBSD'
        it { is_expected.to contain_class('filebeat::install::openbsd') }
      end
    end
  end
end
