require 'spec_helper'

describe 'filebeat::processor', type: :define do
  let :pre_condition do
    'class{"filebeat":
      outputs => {
        "logstash" => {
          "hosts" => [
            "localhost:5044",
          ],
        },
      },
    }'
  end
  let :title do
    'test-processor'
  end

  context 'with no parameters' do
    it { is_expected.to raise_error(Puppet::Error) }
  end

  context 'on Linux' do
    let :facts do
      {
        kernel: 'Linux',
        osfamily: 'Linux',
        rubyversion: '2.3.1',
        filebeat_version: '5.1.2'
      }
    end

    context 'add_cloud_metadata processor' do
      let :params do
        {
          processor_name: 'add_cloud_metadata'
        }
      end

      it do
        is_expected.to contain_file('filebeat-processor-test-processor').with(
          mode: '0644',
          path: '/etc/filebeat/conf.d/10-processor-test-processor.yml',
          content: '---
processors:
- add_cloud_metadata:
    timeout: 3s
'
        )
      end
    end

    context 'drop_event processor with no conditions' do
      let :params do
        {
          processor_name: 'drop_event'
        }
      end

      it { is_expected.to raise_error(Puppet::Error) }
    end

    context 'drop_field processor with no params' do
      let :params do
        {
          processor_name: 'drop_field'
        }
      end

      it { is_expected.to raise_error(Puppet::Error) }
    end
  end
end
