require 'spec_helper_acceptance'

RSpec.shared_examples 'filebeat-oss' do
  describe package('filebeat-oss') do
    it { is_expected.to be_installed }
  end

  describe package('filebeat') do
    it { is_expected.not_to be_installed }
  end

  describe service('filebeat') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe file('/etc/filebeat/filebeat.yml') do
    it { is_expected.to be_file }
    it { is_expected.to contain('---') }
    it { is_expected.not_to contain('xpack') }
  end
end

describe 'filebeat class' do
  let(:pp) do
    <<-HEREDOC
    if $::osfamily == 'Debian' {
      include ::apt

      package { 'apt-transport-https':
        ensure => present,
        before => Class['filebeat'],
      }
    }

    class { 'filebeat':
      major_version => '#{major_version}',
      oss => true,
      outputs => {
        'logstash' => {
          'hosts' => [ 'localhost:5044', ],
        },
      },
    }
    HEREDOC
  end

  context 'with $major_version = 5' do
    let(:major_version) { 5 }

    it 'fails to compile' do
      expect(apply_manifest(pp, expect_failures: true).stderr).to match(%r{OSS repositories are not available for filebeat}i)
    end
  end

  context 'with $major_version = 6' do
    let(:major_version) { 6 }

    it_behaves_like 'an idempotent resource'
    include_examples 'filebeat-oss'
  end
end
