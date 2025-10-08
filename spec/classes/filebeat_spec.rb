require 'spec_helper'

describe 'filebeat' do
  let :pre_condition do
    'include ::filebeat'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os_facts[:kernel] != 'windows'
        it { is_expected.to compile }
      end

      it { is_expected.to contain_class('filebeat') }
      it { is_expected.to contain_class('filebeat::params') }
      it { is_expected.to contain_class('filebeat::install') }
      it { is_expected.to contain_class('filebeat::config') }
      it { is_expected.to contain_class('filebeat::service') }

      # Test that classes are properly contained
      it { is_expected.to contain_class('filebeat::install').that_comes_before('Class[filebeat::config]') }
      it { is_expected.to contain_class('filebeat::config').that_comes_before('Class[filebeat::service]') }

      # Test notification chain
      it { is_expected.to contain_class('filebeat::config').that_notifies('Class[filebeat::service]') }
    end
  end
end
