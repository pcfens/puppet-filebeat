require 'spec_helper_acceptance'

describe "filebeat class:" do

  package_name = 'filebeat'
  service_name = 'filebeat'
  pid_file     = '/var/run/filebeat.pid'

  describe "default parameters" do

    it 'should run successfully' do
      pp = "
      class { 'filebeat':
        outputs => {
          'logstash' => {
            'hosts' => [
              'localhost:5044',
            ],
          },
        },
        prospectors => {
          'system-logs' => {
            log_type => 'system',
            paths    => [
              '/var/log/dmesg',
            ],
            fields   => {
              service => 'system',
              file    => 'dmesg',
            }
          }
        }
      }"

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep 5
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      sleep 5
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    describe package(package_name) do
      it { should be_installed }
    end

    describe file(pid_file) do
      it { should be_file }
      its(:content) { should match /[0-9]+/ }
    end

    it 'Show all running filebeat processes' do
      shell('ps auxfw | grep filebeat | grep -v grep')
    end

  end

end
