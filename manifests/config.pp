class filebeat::config {
  $filebeat_config = delete_undef_values({
    'shutdown_timeout'  => $filebeat::shutdown_timeout,
    'beat_name'         => $filebeat::beat_name,
    'tags'              => $filebeat::tags,
    'queue_size'        => $filebeat::queue_size,
    'max_procs'         => $filebeat::max_procs,
    'fields'            => $filebeat::fields,
    'fields_under_root' => $filebeat::fields_under_root,
    'filebeat'          => {
      'spool_size'       => $filebeat::spool_size,
      'idle_timeout'     => $filebeat::idle_timeout,
      'registry_file'    => $filebeat::registry_file,
      'publish_async'    => $filebeat::publish_async,
      'config_dir'       => $filebeat::config_dir,
      'shutdown_timeout' => $filebeat::shutdown_timeout,
    },
    'output'            => $filebeat::outputs,
    'shipper'           => $filebeat::shipper,
    'logging'           => $filebeat::logging,
    'runoptions'        => $filebeat::run_options,
    'processors'        => $filebeat::processors,
  })

  Filebeat::Prospector <| |> -> File['filebeat.yml']

  case $::kernel {
    'Linux'   : {

      $filebeat_path = $filebeat::real_version ? {
        '1'     => '/usr/bin/filebeat',
        default => '/usr/share/filebeat/bin/filebeat',
      }

      file {'filebeat.yml':
        ensure       => $filebeat::file_ensure,
        path         => $filebeat::config_file,
        content      => template($filebeat::real_conf_template),
        owner        => 'root',
        group        => 'root',
        mode         => $filebeat::config_file_mode,
        validate_cmd => "${filebeat_path} -N -configtest -c %",
        notify       => Service['filebeat'],
        require      => File['filebeat-config-dir'],
      }

      file {'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        owner   => 'root',
        group   => 'root',
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
      }
    } # end Linux

    'Windows' : {
      $filebeat_path = 'c:\Program Files\Filebeat\filebeat.exe'

      file {'filebeat.yml':
        ensure       => $filebeat::file_ensure,
        path         => $filebeat::config_file,
        content      => template($filebeat::real_conf_template),
        validate_cmd => "\"${filebeat_path}\" -N -configtest -c \"%\"",
        notify       => Service['filebeat'],
        require      => File['filebeat-config-dir'],
      }

      file {'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
      }
    } # end Windows

    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
