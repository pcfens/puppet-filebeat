require 'spec_helper'

describe 'filebeat::input' do
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

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:title) { 'test-logs' }
      let(:params) do
        {
          'paths' => [
            '/var/log/auth.log',
            '/var/log/syslog',
          ],
          'doc_type' => 'syslog-beat',
        }
      end

      if os_facts[:kernel] != 'windows'
        it { is_expected.to compile }
      end

      it {
        is_expected.to contain_file('filebeat-test-logs').with(
          notify: 'Service[filebeat]',
        )
      }
    end

    context "with docker input support on #{os}" do
      let(:facts) { os_facts }

      # Docker Support
      let(:title) { 'docker' }
      let(:params) do
        {
          'input_type' => 'docker',
        }
      end

      if os_facts[:kernel] == 'Linux'
        it { is_expected.to compile }

        it {
          is_expected.to contain_file('filebeat-docker').with(
            notify: 'Service[filebeat]',
          )
          is_expected.to contain_file('filebeat-docker').with_content(
            %r{- type: docker\n\s{2}containers:\n\s{4}ids:\n\s{4}- '\*'\n\s{4}path: /var/lib/docker/containers\n\s{4}stream: all\n\s{2}combine_partial: false\n\s{2}cri.parse_flags: false\n},
          )
        }
      end
    end

    context "with filestream input support on #{os}" do
      let(:facts) { os_facts }

      # Filestream
      let(:title) { 'some-filestream' }

      context 'with take_over unset' do
        let(:params) do
          {
            'input_type' => 'filestream',
            'paths' => ['/var/log/foo.log'],
          }
        end

        if os_facts[:kernel] == 'Linux'
          it { is_expected.to compile }

          it {
            is_expected.to contain_file('filebeat-some-filestream').with(
              notify: 'Service[filebeat]',
            )
            is_expected.to contain_file('filebeat-some-filestream').with_content(
              %r{- type: filestream\n\s{2}id: some-filestream\n\s{2}paths:\n\s{2}- /var/log/foo.log},
            )
          }
        end
      end

      context 'with take_over => true' do
        let(:params) do
          {
            'input_type' => 'filestream',
            'paths' => ['/var/log/foo.log'],
            'take_over' => true,
          }
        end

        if os_facts[:kernel] == 'Linux'
          it { is_expected.to compile }

          it {
            is_expected.to contain_file('filebeat-some-filestream').with(
              notify: 'Service[filebeat]',
            )
            is_expected.to contain_file('filebeat-some-filestream').with_content(
              %r{- type: filestream\n\s{2}id: some-filestream\n\s{2}take_over: true\n\s{2}paths:\n\s{2}- /var/log/foo.log},
            )
          }
        end
      end
    end
  end

  on_supported_os.each do |os, os_facts|
    context "with array input support on #{os}" do
      let(:facts) { os_facts }

      # Docker Support
      let(:title) { 'test-array' }
      let(:params) do
        {
          'pure_array' => true,
        }
      end

      if os_facts[:kernel] == 'Linux'
        it { is_expected.to compile }

        it {
          is_expected.to contain_file('filebeat-test-array').with(
            notify: 'Service[filebeat]',
          )
          is_expected.to contain_file('filebeat-test-array').with_content(
            %r{- type: logs\n\s{2}paths:\n\s{2}- "/var/log/auth.log"\n\s{2}- "/var/log/syslog"\n- type: syslog\n\s{2}protocol.tcp:\n\s{4}host: 0.0.0.0:514\n},
          )
        }
      end
    end
  end

  context 'with no parameters' do
    let(:title) { 'test-logs' }
    let(:params) do
      {
        'paths' => [
          '/var/log/auth.log',
          '/var/log/syslog',
        ],
        'doc_type' => 'syslog-beat',
      }
    end

    it { is_expected.to raise_error(Puppet::Error) }
  end
end
