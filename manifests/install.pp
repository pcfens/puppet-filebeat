class filebeat::install {
  case $::kernel {
    'Linux':   {
      class { 'filebeat::install::linux': }
      if $::filebeat::manage_repo {
        class { 'filebeat::repo': }
        Class['filebeat::repo'] -> Class['filebeat::install::linux']
      }
    }
    'Windows': {
      class { 'filebeat::install::windows': }
    }
    default:   {
      fail($filebeat::kernel_fail_message)
    }
  }
}
