# filebeat::install::freebsd
#
# Install the FreeBSD filebeat package
#
# @summary A simple class to install the filebeat package
#
class filebeat::install::freebsd {

  # filebeat, heartbeat, metricbeat, packetbeat are all contained in a
  # single FreeBSD Package (see https://www.freshports.org/sysutils/beats/ )
  ensure_packages (['beats'], {ensure => $filebeat::package_ensure})

  file {'/usr/local/etc/filebeat':
    ensure => directory,
    owner  => 'root',
    group  => 'wheel',
    mode   => '0755',
  }

}
