require 'spec_helper'

describe 'filebeat::prospector', :type => :define do
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
    'apache-logs'
  end

  context 'with no parameters' do
    it { expect { should raise_error(Puppet::Error) } }
  end

  context 'On Linux' do
    let :facts do {
      :kernel => 'Linux',
      :osfamily => 'Linux',
    }
    end

    context 'with file blobs set' do
      let :params do
        {
          :paths => [
            '/var/log/apache2/*.log',
          ],
          :log_type => 'apache',
        }
      end

      it { is_expected.to contain_file('filebeat-apache-logs').with(
        :path => '/etc/filebeat/conf.d/apache-logs.yml',
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
      max_bytes: 10485760
      tail_files: false
      force_close_files: false
      backoff: 1s
      max_backoff: 10s
      backoff_factor: 2
      partial_line_waiting: 5s
      spool_size: 1024
      publish_async: false
      idle_timeout: 5s
      registry_file: .filebeat
',
      )}
    end

    context 'with java app optionals set' do
      let :params do
        {
          :paths => [
            '/var/log/java_app/some.log',
          ],
          :log_type => 'java_app',
          :exclude_lines => [
            '^DEBUG'
          ],
          :include_lines => [
            '^ERROR',
            '^WARN'
          ],
          :exclude_files => [
            '.gz$'
          ],
          :multiline => {
            :pattern => '^\[',
            :negate => 'true',
            :match => 'after'
          }
        }
      end

      it { is_expected.to contain_file('filebeat-apache-logs').with(
        :path => '/etc/filebeat/conf.d/java_app-logs.yml',
        :mode => '0644',
        :content => 'filebeat:
  prospectors:
    - paths:
      - /var/log/apache2/*.log
      encoding: plain
      exclude_lines:
        - ^DEBUG
      include_lines:
        - ^ERROR
        - ^WARN
      exclude_files:
        - .gz$
      fields_under_root: false
      input_type: log
      ignore_older: 24h
      document_type: apache
      scan_frequency: 10s
      harvester_buffer_size: 16384
      max_bytes: 10485760
      multiline:
        pattern: ^\[
        negate: true
        match:after
      tail_files: false
      force_close_files: false
      backoff: 1s
      max_backoff: 10s
      backoff_factor: 2
      partial_line_waiting: 5s
      spool_size: 1024
      publish_async: false
      idle_timeout: 5s
      registry_file: .filebeat
',
      )}
    end
  end

  context 'On Windows' do
    let :facts do {
      :kernel => 'Windows',
    }
    end

    context 'with file blobs set' do
      let :params do
        {
          :paths => [
            'C:/Program Files/Apache Software Foundation/Apache2.2/*.log',
          ],
          :log_type => 'apache',
        }
      end

      it { is_expected.to contain_file('filebeat-apache-logs').with(
        :path => 'C:/Program Files/Filebeat/conf.d/apache-logs.yml',
        :content => 'filebeat:
  prospectors:
    - paths:
      - C:/Program Files/Apache Software Foundation/Apache2.2/*.log
      encoding: plain
      fields_under_root: false
      input_type: log
      ignore_older: 24h
      document_type: apache
      scan_frequency: 10s
      harvester_buffer_size: 16384
      max_bytes: 10485760
      tail_files: false
      force_close_files: false
      backoff: 1s
      max_backoff: 10s
      backoff_factor: 2
      partial_line_waiting: 5s
      spool_size: 1024
      publish_async: false
      idle_timeout: 5s
      registry_file: .filebeat
',
      )}
    end
  end
end
