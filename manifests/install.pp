class filebeat::install {
  case $::kernel {
    'Linux':   {
      contain filebeat::install::linux
      if $::filebeat::manage_repo {
        contain filebeat::repo
        Class['filebeat::repo'] -> Class['filebeat::install::linux']
      }
    }
    'Windows': {
      contain filebeat::install::windows
    }
    default:   {
      fail($filebeat::kernel_fail_message)
    }
  }
}
