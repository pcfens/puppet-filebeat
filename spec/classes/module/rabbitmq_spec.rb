# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::rabbitmq' do
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
      is_expected.to contain_file('filebeat-module-rabbitmq').with_content(
      %r{- module: rabbitmq\n\s{2}log:\n\s{4}enabled: false\n\n},
    )}
  end

  context 'on log enabled with paths' do
    let(:params) do
      {
        'log_enabled' => true,
        'log_paths' => ['/var/log/rabbitmq.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-rabbitmq').with_content(
        <<-EOS
### Filebeat configuration managed by Puppet ###
---
- module: rabbitmq
  log:
    enabled: true
    var.paths:
    - "/var/log/rabbitmq.log"

EOS
    )
    }
  end
end
