class filebeat::params {
  $package_ensure = present
  $manage_repo    = true
  $service_ensure = running
  $service_enable = true
  $spool_size     = 1024
  $idle_timeout   = '5s'
  $registry_file  = '.filebeat'
  $purge_conf_dir = true
  $outputs        = {}
  $shipper        = {}
  $logging        = {}
  $conf_template  = "${module_name}/filebeat.yml.erb"

  $fail_message     = "${::kernel} is not yet supported by filebeat."

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

    default : {
      fail($fail_message)
    }
  }
}
