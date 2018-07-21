# filebeat::install::freebsd
#
# Install the FreeBSD filebeat package
#
# @summary A simple class to install the filebeat package
#
class filebeat::install::freebsd {
  if $filebeat::oss {
    warning('No OSS version of filebeat available under OpenBSD')
  }

  package {'filebeat':
    ensure => $filebeat::package_ensure,
    name   => $filebeat::real_package_name,
  }
}
