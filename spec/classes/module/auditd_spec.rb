# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::auditd' do
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
      is_expected.to contain_file('filebeat-module-auditd').with_content(
      %r{- module: auditd\n\s{2}log:\n\s{4}enabled: false\n\n},
    )
    }
  end

  context 'on log enabled with paths' do
    let(:params) do
      {
        'log_enabled' => true,
        'log_paths' => ['/var/log/audit/audit.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-auditd').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: auditd
  log:
    enabled: true
    var.paths:
    - "/var/log/audit/audit.log"

EOS
      )
    }
  end
end
