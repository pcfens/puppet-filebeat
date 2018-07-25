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

  $absent_package_name = $filebeat::oss ? {
    false   => "${$filebeat::package_name}-oss",
    default => $filebeat::package_name,
  }

  # the official debian packages filebeat and filebeat-oss
  # do not conflict with each other according to their
  # meta data; but they have a similar content, resulting
  # in errors during installation
  package { 'conflicting filebeat package':
    ensure => absent,
    name   => $absent_package_name,
  }
  -> package { 'filebeat':
    ensure => $filebeat::package_ensure,
    name   => $filebeat::real_package_name,
  }
}
