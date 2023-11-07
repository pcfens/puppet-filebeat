require 'facter'
Facter.add('filebeat_version') do
  confine 'kernel' => ['FreeBSD', 'OpenBSD', 'Linux', 'Windows', 'SunOS']
  if File.executable?('/usr/bin/filebeat')
    filebeat_version = Facter::Util::Resolution.exec('/usr/bin/filebeat version')
    if filebeat_version.empty?
      filebeat_version = Facter::Util::Resolution.exec('/usr/bin/filebeat --version')
    end
  elsif File.executable?('/usr/local/bin/filebeat')
    filebeat_version = Facter::Util::Resolution.exec('/usr/local/bin/filebeat version')
    if filebeat_version.empty?
      filebeat_version = Facter::Util::Resolution.exec('/usr/local/bin/filebeat --version')
    end
  elsif File.executable?('/opt/local/bin/filebeat')
    filebeat_version = Facter::Util::Resolution.exec('/opt/local/bin/filebeat version')
    if filebeat_version.empty?
      filebeat_version = Facter::Util::Resolution.exec('/opt/local/bin/filebeat --version')
    end
  elsif File.executable?('/usr/share/filebeat/bin/filebeat')
    filebeat_version = Facter::Util::Resolution.exec('/usr/share/filebeat/bin/filebeat --version')
  elsif File.executable?('/usr/local/sbin/filebeat')
    filebeat_version = Facter::Util::Resolution.exec('/usr/local/sbin/filebeat version')
    if filebeat_version.empty?
      filebeat_version = Facter::Util::Resolution.exec('/usr/local/sbin/filebeat --version')
    end
  elsif File.exist?('c:\Program Files\Filebeat\filebeat.exe')
    filebeat_version = Facter::Util::Resolution.exec('"c:\Program Files\Filebeat\filebeat.exe" version')
    if filebeat_version.empty?
      filebeat_version = Facter::Util::Resolution.exec('"c:\Program Files\Filebeat\filebeat.exe" --version')
    end
  end
  setcode do
    %r{^filebeat version ([^\s]+)?}.match(filebeat_version)[1] rescue nil
  end
end
