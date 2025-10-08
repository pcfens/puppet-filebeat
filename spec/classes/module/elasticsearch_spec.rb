# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::elasticsearch' do
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
      is_expected.to contain_file('filebeat-module-elasticsearch').with_content(
      # rubocop:disable Layout/LineLength
      %r{- module: elasticsearch\n\s{2}server:\n\s{4}enabled: false\n\s{2}gc:\n\s{4}enabled: false\n\s{2}audit:\n\s{4}enabled: false\n\s{2}deprecation:\n\s{4}enabled: false\n\s{2}slowlog:\n\s{4}enabled: false\n\n},
      # rubocop:enable Layout/LineLength
    )
    }
  end

  context 'on server,gc,audit,slowlog and deprecation enabled with paths' do
    let(:params) do
      {
        'server_enabled' => true,
        'server_paths' => ['/var/log/elasticsearch/*.log'],
        'gc_enabled' => true,
        'gc_paths' => ['/var/log/elasticsearch/gc.log*'],
        'audit_enabled' => true,
        'audit_paths' => ['/var/log/elasticsearch/audit.log'],
        'slowlog_enabled' => true,
        'slowlog_paths' => ['/var/log/elasticsearch/*_search_slowlog.log'],
        'deprecation_enabled' => true,
        'deprecation_paths' => ['/var/log/elasticsearch/*_deprecation.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-elasticsearch').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: elasticsearch
  server:
    enabled: true
    var.paths:
    - "/var/log/elasticsearch/*.log"
  gc:
    enabled: true
    var.paths:
    - "/var/log/elasticsearch/gc.log*"
  audit:
    enabled: true
    var.paths:
    - "/var/log/elasticsearch/audit.log"
  deprecation:
    enabled: true
    var.paths:
    - "/var/log/elasticsearch/*_deprecation.log"
  slowlog:
    enabled: true
    var.paths:
    - "/var/log/elasticsearch/*_search_slowlog.log"

EOS
      )
    }
  end
end
