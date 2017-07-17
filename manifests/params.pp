class filebeat::params {
  $manage_repo          = true
  $service_ensure       = running
  $service_enable       = true
  $spool_size           = 2048
  $idle_timeout         = '5s'
  $publish_async        = false
  $shutdown_timeout     = 0
  $beat_name            = $::fqdn
  $tags                 = []
  $queue_size           = 1000
  $max_procs            = undef
  $config_dir_mode      = '0755'
  $config_file_mode     = '0644'
  $purge_conf_dir       = true
  $fields               = {}
  $fields_under_root    = false
  $outputs              = {}
  $shipper              = {}
  $logging              = {}
  $run_options          = {}
  $kernel_fail_message  = "${::kernel} is not supported by filebeat."
  $conf_template        = "${module_name}/pure_hash.yml.erb"
  $disable_config_test  = false

  case $::kernel {
    'Linux'   : {
      $package_ensure  = present
      $config_file     = '/etc/filebeat/filebeat.yml'
      $config_dir      = '/etc/filebeat/conf.d'
      $registry_file   = '/var/lib/filebeat/registry'

      # These parameters are ignored if/until tarball installs are supported in Linux
      $tmp_dir         = '/tmp'
      $install_dir     = undef
      case $::osfamily {
        'RedHat': {
          $service_provider = 'redhat'
        }
        default: {
          $service_provider = undef
        }
      }
    }

    'Windows' : {
      $package_ensure   = '5.1.1'
      $config_file      = 'C:/Program Files/Filebeat/filebeat.yml'
      $config_dir       = 'C:/Program Files/Filebeat/conf.d'
      $registry_file    = 'C:/ProgramData/filebeat/registry'
      $install_dir      = 'C:/Program Files'
      $tmp_dir          = 'C:/Windows/Temp'
      $service_provider = undef
    }

    default : {
      fail($kernel_fail_message)
    }
  }
}
