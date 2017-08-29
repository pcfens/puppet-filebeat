class filebeat::install::freebsd {
  ensure_packages (['beats'], {ensure => $filebeat::package_ensure})
  file {'/usr/local/etc/rc.d/filebeat':
    ensure => present,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0555',
    source => 'puppet:///modules/filebeat/FreeBSD/rc.d_filebeat',
  }
  file {'/usr/local/etc/filebeat':
    ensure => directory,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0755',
  }
 
}
