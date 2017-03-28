class filebeat::service {
  service { 'filebeat':
    ensure   => $filebeat::real_service_ensure,
    enable   => $filebeat::service_enable,
    provider => $filebeat::service_provider,
  }
  
  if $filebeat::service_enable and $::kernel == 'FreeBSD' {
    file_line {'/etc/rc.conf: filebeat_enable="YES"':
      ensure => present,
      path   => '/etc/rc.conf',
      line   => 'filebeat_enable="YES"',
    }
  }
}
