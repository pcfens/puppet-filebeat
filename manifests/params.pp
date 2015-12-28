class filebeat::params {
  $package_ensure = present
  $manage_repo    = true
  $service_ensure = running
  $service_enable = true
  $spool_size     = 1024
  $idle_timeout   = '5s'
  $registry_file  = '.filebeat'
  $config_dir     = '/etc/filebeat/conf.d'
  $purge_conf_dir = true
  $outputs        = {}
  $shipper        = {}
  $logging        = {}

  $fail_message     = "${::kernel} is not yet supported by this module."

  case $::kernel {
    'Linux'   : {
      $config_dir = '/etc/filebeat/conf.d'
    }

    'Windows' : {
      $config_dir   = 'C:/Program Files/Filebeat/conf.d'
      $download_url = 'https://download.elastic.co/beats/filebeat/filebeat-1.0.1-windows.zip'
      $install_dir  = 'C:/Program Files'
      $tmp_dir      = 'C:/Temp'
    }
    
    default   : {
      fail($fail_message)
    }
  }
}
