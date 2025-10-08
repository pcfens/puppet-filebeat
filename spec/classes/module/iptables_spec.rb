# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::iptables' do
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
      is_expected.to contain_file('filebeat-module-iptables').with_content(
      %r{- module: iptables\n\s{2}log:\n\s{4}enabled: false\n\n},
    )
    }
  end

  context 'on iptables logfile' do
    let(:params) do
      {
        'log_enabled' => true,
        'log_paths' => ['/var/log/ip6tables.log', '/var/log/iptables.log'],
        'log_input' => 'file',
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-iptables').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: iptables
  log:
    enabled: true
    var.input: file
    var.paths:
    - "/var/log/ip6tables.log"
    - "/var/log/iptables.log"

EOS
      )
    }
  end

  context 'on iptables with syslog' do
    let(:params) do
      {
        'log_enabled' => true,
        'log_input' => 'syslog',
        'log_syslog_host' => '0.0.0.0',
        'log_syslog_port' => 514,
        'log_tags' => [
          'iptables',
        ]
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-iptables').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: iptables
  log:
    enabled: true
    var.input: syslog
    var.syslog_host: 0.0.0.0
    var.syslog_port: 514
    var.tags:
    - iptables

EOS
      )
    }
  end
end
