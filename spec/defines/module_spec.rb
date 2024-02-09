# frozen_string_literal: true

require 'spec_helper'

describe 'filebeat::module' do
  let :pre_condition do
    'class { "filebeat":
        outputs => {
          "logstash" => {
            "hosts" => [
              "localhost:5044",
            ],
          },
        },
        inputs => [
          {
            "type" => "logs",
            "paths" => [
              "/var/log/auth.log",
              "/var/log/syslog",
            ],
          },
          {
            "type" => "syslog",
            "protocol.tcp" => {
              "host" => "0.0.0.0:514",
            },
          },
        ],
      }'
  end

  let(:title) { 'test' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      if os_facts[:kernel] == 'Linux'
        it { is_expected.to compile }

        it {
          is_expected.to contain_file('filebeat-module-test').with(
            notify: 'Service[filebeat]',
          )
          is_expected.to contain_file('filebeat-module-test').with_content(
            %r{- module: test},
          )
        }
      end
    end
  end
end
