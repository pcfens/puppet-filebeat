# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::kibana' do
  let :pre_condition do
    'include ::filebeat'
  end

  let(:facts) { 
    {
      :kernel => 'Linux',
      :os => {
        :family => 'Debian',
        :name => 'Ubuntu',
      }
    } 
  }
  
  context 'on default values' do
    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-kibana').with_content(
      %r{- module: kibana\n\s{2}log:\n\s{4}enabled: false\n\s{2}audit:\n\s{4}enabled: false\n\n},
    )}
  end

  context 'on log and audit enabled with paths' do
    let(:params) do
      {
        'log_enabled' => true,
        'log_paths' => ['/var/log/kibana.log'],
        'audit_enabled' => true,
        'audit_paths' => ['/var/log/kibana-audit.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-kibana').with_content(
        <<-EOS
### Filebeat configuration managed by Puppet ###
---
- module: kibana
  log:
    enabled: true
    var.paths:
    - "/var/log/kibana.log"
  audit:
    enabled: true
    var.paths:
    - "/var/log/kibana-audit.log"

EOS
    )
    }
  end
end
