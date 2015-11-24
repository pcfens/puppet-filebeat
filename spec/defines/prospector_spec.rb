require 'spec_helper'

describe 'filebeat::prospector', :type => :define do
  let :title do
    'apache-logs'
  end

  context 'with no parameters' do
    it { expect { should raise_error(Puppet::Error) } }
  end

  context 'with file blobs set' do
    let :params do
      {
        :paths => [
          '/var/log/apache2/*.log',
        ],
        :document_type => 'apache',
      }
    end

    it { is_expected.to contain_file('filebeat-apache-logs').with(
      :path => '/apache-logs.yml',
      :mode => '0644',
      :content => 'filebeat:
  prospectors:
    - paths:
      - /var/log/apache2/*.log
      encoding: plain
      fields_under_root: false
      input_type: log
      ignore_older: 24h
      document_type: apache
      scan_frequency: 10s
      harvester_buffer_size: 16384
      tail_files: false
      force_close_files: false
      backoff: 1s
      max_backoff: 10s
      backoff_factor: 2
      partial_line_waiting: 5s
',
    )}
  end
end
