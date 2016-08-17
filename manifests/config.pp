class filebeat::config {

  if versioncmp($::filebeat::version, '5') < 0 {
    $filebeat_config = {
      'filebeat'   => {
        'spool_size'    => $filebeat::spool_size,
        'idle_timeout'  => $filebeat::idle_timeout,
        'registry_file' => $filebeat::registry_file,
        'publish_async' => $filebeat::publish_async,
        'config_dir'    => $filebeat::config_dir,
      },
      'output'     => $filebeat::outputs,
      'shipper'    => $filebeat::shipper,
      'logging'    => $filebeat::logging,
      'runoptions' => $filebeat::run_options,
    }
  } else {
    $filebeat_config = {
      'name'                  => $filebeat::beat_name,
      'tags'                  => $filebeat::tags,
      'fields'                => $filebeat::fields,
      'fields_under_root'     => $filebeat::fields_under_root,
      'ignore_outgoing'       => $filebeat::ignore_outgoing,
      'refresh_topology_freq' => $filebeat::refresh_topology_freq,
      'topology_expire'       => $filebeat::topology_expire,
      'queue_size'            => $filebeat::queue_size,
      'max_procs'             => $filebeat::max_procs,
      'filebeat'              => {
        'spool_size'    => $filebeat::spool_size,
        'publish_async' => $filebeat::publish_async,
        'idle_timeout'  => $filebeat::idle_timeout,
        'registry_file' => $filebeat::registry_file,
        'config_dir'    => $filebeat::config_dir,
      },
      'output'                => $filebeat::outputs,
      'logging'               => $filebeat::logging,
    }
  }

  case $::kernel {
    'Linux'   : {
      file {'filebeat.yml':
        ensure  => file,
        path    => $filebeat::config_file,
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
        path    => $filebeat::config_file,
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
