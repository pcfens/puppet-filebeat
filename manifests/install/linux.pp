# filebeat::install::linux
#
# Install the linux filebeat package
#
# @summary A simple class to install the filebeat package
#
class filebeat::install::linux {
  if $::kernel != 'Linux' {
    fail('filebeat::install::linux shouldn\'t run on Windows')
  }

  package { $filebeat::package_name:
    ensure => $filebeat::package_ensure,
  }
}
