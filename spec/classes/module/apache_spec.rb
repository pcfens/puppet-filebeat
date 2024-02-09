# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::apache' do
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
      is_expected.to contain_file('filebeat-module-apache').with_content(
      %r{- module: apache\n\s{2}access:\n\s{4}enabled: false\n\s{2}error:\n\s{4}enabled: false\n\n},
    )}
  end

  context 'on access and error enabled with paths' do
    let(:params) do
      {
        'access_enabled' => true,
        'access_paths' => ['/var/log/apache2/access.log', '/var/log/apache2/*-access.log'],
        'error_enabled' => true,
        'error_paths' => ['/var/log/apache2/error.log', '/var/log/apache2/*-error.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-apache').with_content(
        <<-EOS
### Filebeat configuration managed by Puppet ###
---
- module: apache
  access:
    enabled: true
    var.paths:
    - "/var/log/apache2/access.log"
    - "/var/log/apache2/*-access.log"
  error:
    enabled: true
    var.paths:
    - "/var/log/apache2/error.log"
    - "/var/log/apache2/*-error.log"

EOS
    )
    }
  end
end
