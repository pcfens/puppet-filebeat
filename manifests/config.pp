class filebeat::config {
  $filebeat_config = {
    'filebeat'   => {
      'spool_size'    => $filebeat::spool_size,
      'idle_timeout'  => $filebeat::idle_timeout,
      'registry_file' => $filebeat::registry_file,
      'config_dir'    => $filebeat::config_dir,
    },
    'output'     => $filebeat::outputs,
    'shipper'    => $filebeat::shipper,
    'logging'    => $filebeat::logging,
    'runoptions' => $filebeat::run_options,
  }

  case $::kernel {
    'Linux'   : {
      file {'filebeat.yml':
        ensure  => file,
        path    => '/etc/filebeat/filebeat.yml',
        content => template($filebeat::conf_template),
        owner   => 'root',
        group   => 'root',
        mode    => $filebeat::config_file_mode,
        notify  => Service['filebeat'],
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        owner   => 'root',
        group   => 'root',
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Linux

    'Windows' : {
      file {'filebeat.yml':
        ensure  => file,
        path    => 'C:/Program Files/Filebeat/filebeat.yml',
        content => template($filebeat::conf_template),
        notify  => Service['filebeat'],
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Windows

    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
