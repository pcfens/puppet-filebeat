# filebeat::install
#
# A private class to manage the installation of Filebeat
#
# @summary A private class that manages the install of Filebeat
class filebeat::install {
  case $facts['kernel'] {
    'Linux':   {
      if $filebeat::manage_repo {
        class { 'filebeat::repo': }
        Class['filebeat::repo'] -> Class['filebeat::install::linux']
      }
      class { 'filebeat::install::linux':
        notify => Class['filebeat::service'],
      }
      contain filebeat::install::linux
    }
    'SunOS': {
      class { 'filebeat::install::sunos':
        notify => Class['filebeat::service'],
      }
      contain filebeat::install::sunos
    }
    'FreeBSD': {
      class { 'filebeat::install::freebsd':
        notify => Class['filebeat::service'],
      }
      contain filebeat::install::freebsd
    }
    'OpenBSD': {
      class { 'filebeat::install::openbsd': }
      contain filebeat::install::openbsd
    }
    'Windows': {
      class { 'filebeat::install::windows':
        notify => Class['filebeat::service'],
      }
      contain filebeat::install::windows
    }
    default:   {
      fail($filebeat::kernel_fail_message)
    }
  }
}
