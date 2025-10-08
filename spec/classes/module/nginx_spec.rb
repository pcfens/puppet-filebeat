# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module::nginx' do
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
      is_expected.to contain_file('filebeat-module-nginx').with_content(
      %r{- module: nginx\n\s{2}access:\n\s{4}enabled: false\n\s{2}error:\n\s{4}enabled: false\n\s{2}ingress_controller:\n\s{4}enabled: false\n\n},
    )
    }
  end

  context 'on access, error and ingress_controller enabled with paths' do
    let(:params) do
      {
        'access_enabled' => true,
        'access_paths' => ['/var/log/nginx/access.log'],
        'error_enabled' => true,
        'error_paths' => ['/var/log/nginx/error.log'],
        'ingress_controller_enabled' => true,
        'ingress_controller_paths' => ['/var/log/nginx/ingress_controller.log'],
      }
    end

    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_file('filebeat-module-nginx').with_content(
        <<-EOS,
### Filebeat configuration managed by Puppet ###
---
- module: nginx
  access:
    enabled: true
    var.paths:
    - "/var/log/nginx/access.log"
  error:
    enabled: true
    var.paths:
    - "/var/log/nginx/error.log"
  ingress_controller:
    enabled: true
    var.paths:
    - "/var/log/nginx/ingress_controller.log"

EOS
      )
    }
  end
end
