# filebeat::config
#
# Manage the configuration files for filebeat
#
# @summary A private class to manage the filebeat config file
class filebeat::config {
  $major_version = $filebeat::major_version

  if versioncmp($major_version, '6') >= 0 {
    $filebeat_config = delete_undef_values({
      'shutdown_timeout'  => $filebeat::shutdown_timeout,
      'name'              => $filebeat::beat_name,
      'tags'              => $filebeat::tags,
      'max_procs'         => $filebeat::max_procs,
      'fields'            => $filebeat::fields,
      'fields_under_root' => $filebeat::fields_under_root,
      'filebeat'          => {
        'registry_file'    => $filebeat::registry_file,
        'config_dir'       => $filebeat::config_dir,
        'shutdown_timeout' => $filebeat::shutdown_timeout,
        'config'           => $filebeat::config_hash,
      },
      'output'            => $filebeat::outputs,
      'shipper'           => $filebeat::shipper,
      'logging'           => $filebeat::logging,
      'runoptions'        => $filebeat::run_options,
      'processors'        => $filebeat::processors,
      'setup'             => $filebeat::setup,
    })
  } else {
    $filebeat_config = delete_undef_values({
      'shutdown_timeout'  => $filebeat::shutdown_timeout,
      'name'              => $filebeat::beat_name,
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
        'config'           => $filebeat::config_hash,
      },
      'output'            => $filebeat::outputs,
      'shipper'           => $filebeat::shipper,
      'logging'           => $filebeat::logging,
      'runoptions'        => $filebeat::run_options,
      'processors'        => $filebeat::processors,
    })
  }

  Filebeat::Prospector <| |> -> File['filebeat.yml']

  case $::kernel {
    'Linux'   : {
      $validate_cmd = $filebeat::disable_config_test ? {
        true    => undef,
        default => $major_version ? {
          '5'     => "${filebeat::filebeat_path} -N -configtest -c %",
          default => "${filebeat::filebeat_path} -c % test config",
        },
      }

      file {'filebeat.yml':
        ensure       => $filebeat::file_ensure,
        path         => $filebeat::config_file,
        content      => template($filebeat::conf_template),
        owner        => $filebeat::config_file_owner,
        group        => $filebeat::config_file_group,
        mode         => $filebeat::config_file_mode,
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat-config-dir'],
      }

      file {'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        owner   => $filebeat::config_dir_owner,
        group   => $filebeat::config_dir_group,
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
      }
    } # end Linux

    'FreeBSD'   : {
      $validate_cmd = $filebeat::disable_config_test ? {
        true    => undef,
        default => '/usr/local/sbin/filebeat -N -configtest -c %',
      }

      file {'filebeat.yml':
        ensure       => $filebeat::file_ensure,
        path         => $filebeat::config_file,
        content      => template($filebeat::conf_template),
        owner        => $filebeat::config_file_owner,
        group        => $filebeat::config_file_group,
        mode         => $filebeat::config_file_mode,
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat-config-dir'],
      }

      file {'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        owner   => $filebeat::config_dir_owner,
        group   => $filebeat::config_dir_group,
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
      }
    } # end FreeBSD

    'Windows' : {
      $cmd_install_dir = regsubst($filebeat::install_dir, '/', '\\', 'G')
      $filebeat_path = join([$cmd_install_dir, 'Filebeat', 'filebeat.exe'], '\\')

      $validate_cmd = $filebeat::disable_config_test ? {
        true    => undef,
        default => "\"${filebeat_path}\" -N -configtest -c \"%\"",
      }

      file {'filebeat.yml':
        ensure       => $filebeat::file_ensure,
        path         => $filebeat::config_file,
        content      => template($filebeat::conf_template),
        validate_cmd => $validate_cmd,
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
