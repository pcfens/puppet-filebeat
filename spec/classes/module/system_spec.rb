# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::system' do
  let :pre_condition do
    'include ::filebeat'
  end

  let(:facts) do
    {
      kernel: 'Linux',
      os: {
        family: 'Debian',
        name: 'Ubuntu',
      }
    }
  end

  context 'on default values' do
    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-system').with_content(
      %r{- module: system\n\s{2}syslog:\n\s{4}enabled: false\n\s{2}auth:\n\s{4}enabled: false\n\n},
    )
    }
  end

  context 'on log and slowlog enabled with paths' do
    let(:params) do
      {
        'syslog_enabled' => true,
        'syslog_paths' => ['/var/log/syslog'],
        'auth_enabled' => true,
        'auth_paths' => ['/var/log/auth.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-system').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: system
  syslog:
    enabled: true
    var.paths:
    - "/var/log/syslog"
  auth:
    enabled: true
    var.paths:
    - "/var/log/auth.log"

EOS
      )
    }
  end
end
