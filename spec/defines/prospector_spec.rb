require 'spec_helper'

describe 'filebeat::prospector', type: :define do
  let :pre_condition do
    'class { "filebeat":
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
    'test-logs'
  end

  context 'with no parameters' do
    it { is_expected.to raise_error(Puppet::Error) }
  end
end
