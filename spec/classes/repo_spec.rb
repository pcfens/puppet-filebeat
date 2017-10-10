require 'spec_helper'

describe 'filebeat::repo' do
  let :pre_condition do
    'include ::filebeat'
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      case os_facts[:kernel]
      when 'Linux'
        it { is_expected.to compile }
        case os_facts[:osfamily]
        when 'Debian'
          it {
            is_expected.to contain_apt__source('beats').with(
              ensure: 'present',
              location: 'https://artifacts.elastic.co/packages/5.x/apt',
            )
          }
        when 'RedHat'
          it {
            is_expected.to contain_yumrepo('beats').with(
              ensure: 'present',
              baseurl: 'https://artifacts.elastic.co/packages/5.x/yum',
            )
          }
        end
      else
        it { is_expected.not_to compile }
      end
    end
  end
end
