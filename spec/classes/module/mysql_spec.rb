# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::mysql' do
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
      is_expected.to contain_file('filebeat-module-mysql').with_content(
      %r{- module: mysql\n\s{2}error:\n\s{4}enabled: false\n\s{2}slowlog:\n\s{4}enabled: false\n\n},
    )}
  end

  context 'on error and slowlog enabled with paths' do
    let(:params) do
      {
        'error_enabled' => true,
        'error_paths' => ['/var/log/mysql/error.log'],
        'slowlog_enabled' => true,
        'slowlog_paths' => ['/var/log/mysql/slowlog.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-mysql').with_content(
        <<-EOS
### Filebeat configuration managed by Puppet ###
---
- module: mysql
  error:
    enabled: true
    var.paths:
    - "/var/log/mysql/error.log"
  slowlog:
    enabled: true
    var.paths:
    - "/var/log/mysql/slowlog.log"

EOS
    )
    }
  end
end
