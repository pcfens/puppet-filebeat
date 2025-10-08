# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::redis' do
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
      is_expected.to contain_file('filebeat-module-redis').with_content(
      %r{- module: redis\n\s{2}log:\n\s{4}enabled: false\n\s{2}slowlog:\n\s{4}enabled: false\n\n},
    )
    }
  end

  context 'on log and slowlog enabled with paths' do
    let(:params) do
      {
        'log_enabled' => true,
        'log_paths' => ['/var/log/redis.log'],
        'slowlog_enabled' => true,
        'slowlog_hosts' => ['localhost:6379'],
        'slowlog_password' => 'password',
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-redis').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: redis
  log:
    enabled: true
    var.paths:
    - "/var/log/redis.log"
  slowlog:
    enabled: true
    var.hosts:
    - localhost:6379
    var.password: password

EOS
      )
    }
  end
end
