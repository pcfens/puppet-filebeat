require 'spec_helper'

describe 'filebeat::install::linux' do
  let :pre_condition do
    "class { 'filebeat': oss => #{oss}, package_name => #{package_name} }"
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default package name' do
        let(:oss) { false }
        let(:package_name) { :undef }

        case os_facts[:kernel]
        when 'Linux'
          it { is_expected.to compile }
          it {
            is_expected.to contain_package('filebeat').with(
              'ensure' => 'present',
              'name'   => 'filebeat',
            )
          }
        else
          it { is_expected.not_to compile }
        end
      end

      context 'with OSS package' do
        let(:oss) { true }
        let(:package_name) { :undef }

        case os_facts[:kernel]
        when 'Linux'
          it { is_expected.to compile }
          it {
            is_expected.to contain_package('filebeat').with(
              'ensure' => 'present',
              'name'   => 'filebeat-oss',
            )
          }
        else
          it { is_expected.not_to compile }
        end
      end

      context 'with custom package name' do
        let(:oss) { false }
        let(:package_name) { '"filebeat-custom"' }

        case os_facts[:kernel]
        when 'Linux'
          it { is_expected.to compile }
          it {
            is_expected.to contain_package('filebeat').with(
              'ensure' => 'present',
              'name'   => 'filebeat-custom',
            )
          }
        else
          it { is_expected.not_to compile }
        end
      end
    end
  end
end
