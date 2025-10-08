# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::sophos' do
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
      is_expected.to contain_file('filebeat-module-sophos').with_content(
      %r{- module: sophos\n\s{2}xg:\n\s{4}enabled: false\n\s{2}utm:\n\s{4}enabled: false\n\n},
    )
    }
  end

  context 'on xg and utm enabled with paths' do
    let(:params) do
      {
        'xg_enabled' => true,
        'xg_input' => 'file',
        'xg_paths' => ['/var/log/xg.log'],
        'utm_enabled' => true,
        'utm_input' => 'file',
        'utm_paths' => ['/var/log/utm.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-sophos').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: sophos
  xg:
    enabled: true
    var.input: file
    var.paths:
    - "/var/log/xg.log"
  utm:
    enabled: true
    var.input: file
    var.paths:
    - "/var/log/utm.log"

EOS
      )
    }
  end

  context 'on xg and utm enabled with syslog input' do
    let(:params) do
      {
        'xg_enabled' => true,
        'xg_input' => 'udp',
        'xg_syslog_host' => '0.0.0.0',
        'xg_syslog_port' => 514,
        'xg_host_name' => 'sophos-xg',
        'utm_enabled' => true,
        'utm_input' => 'tcp',
        'utm_syslog_host' => '0.0.0.0',
        'utm_syslog_port' => 515,
        'utm_tz_offset' => '-07:00',
        'utm_rsa_fields' => true,
        'utm_keep_raw_fields' => true,
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-sophos').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: sophos
  xg:
    enabled: true
    var.input: udp
    var.syslog_host: 0.0.0.0
    var.syslog_port: 514
    var.host_name: sophos-xg
  utm:
    enabled: true
    var.input: tcp
    var.syslog_host: 0.0.0.0
    var.syslog_port: 515
    var.tz_offset: "-07:00"
    var.rsa_fields: true
    var.keep_raw_fields: true

EOS
      )
    }
  end
end
