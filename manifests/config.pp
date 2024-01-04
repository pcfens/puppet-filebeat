# filebeat::config
#
# Manage the configuration files for filebeat
#
# @summary A private class to manage the filebeat config file
class filebeat::config {
  $major_version = $filebeat::major_version

  if 'ilm.policy' in $filebeat::setup {
    file { "${filebeat::config_dir}/ilm_policy.json":
      content => to_json({ 'policy' => $filebeat::setup['ilm.policy'] }),
      notify  => Service['filebeat'],
      require => File['filebeat-config-dir'],
    }
    $setup = $filebeat::setup - 'ilm.policy' + { 'ilm.policy_file' => "${filebeat::config_dir}/ilm_policy.json" }
  } else {
    $setup = $filebeat::setup
  }

  if versioncmp($major_version, '6') >= 0 {
    $filebeat_config_temp = delete_undef_values({
        'name'              => $filebeat::beat_name,
        'tags'              => $filebeat::tags,
        'max_procs'         => $filebeat::max_procs,
        'fields'            => $filebeat::fields,
        'fields_under_root' => $filebeat::fields_under_root,
        'filebeat'          => {
          'config.inputs' => {
            'enabled' => true,
            'path'    => "${filebeat::config_dir}/*.yml",
          },
          'config.modules' => {
            'enabled' => $filebeat::enable_conf_modules,
            'path'    => "${filebeat::modules_dir}/*.yml",
          },
          'modules'             => $filebeat::modules,
          'overwrite_pipelines' => $filebeat::overwrite_pipelines,
          'shutdown_timeout'    => $filebeat::shutdown_timeout,
          'registry'            => {
            'path'             => $filebeat::registry_path,
            'file_permissions' => $filebeat::registry_file_permissions,
            'flush'            => $filebeat::registry_flush,
          },
          'autodiscover'      => $filebeat::autodiscover,
        },
        'http'              => $filebeat::http,
        'cloud'             => $filebeat::cloud,
        'queue'             => $filebeat::queue,
        'output'            => $filebeat::outputs,
        'shipper'           => $filebeat::shipper,
        'logging'           => $filebeat::logging,
        'runoptions'        => $filebeat::run_options,
        'processors'        => $filebeat::processors,
        'monitoring'        => $filebeat::monitoring,
        'setup'             => $setup,
    })
    # Add the 'xpack' section if supported (version >= 6.1.0) and not undef
    if $filebeat::xpack and versioncmp($filebeat::package_ensure, '6.1.0') >= 0 {
      $filebeat_config_xpack = deep_merge($filebeat_config_temp, { 'xpack' => $filebeat::xpack })
    }
    else {
      $filebeat_config_xpack = $filebeat_config_temp
    }
    # Add the 'features' section if supported (version >= 8.7.0) and not undef
    if $filebeat::features and versioncmp($filebeat::package_ensure, '8.7.0') >= 0 {
      $filebeat_config = deep_merge($filebeat_config_xpack, { 'features' => $filebeat::features })
    }
    else {
      $filebeat_config = $filebeat_config_xpack
    }
  } else {
    $filebeat_config_temp = delete_undef_values({
        'shutdown_timeout'  => $filebeat::shutdown_timeout,
        'name'              => $filebeat::beat_name,
        'tags'              => $filebeat::tags,
        'queue_size'        => $filebeat::queue_size,
        'max_procs'         => $filebeat::max_procs,
        'fields'            => $filebeat::fields,
        'fields_under_root' => $filebeat::fields_under_root,
        'filebeat'          => {
          'config_dir'          => $filebeat::config_dir,
          'idle_timeout'        => $filebeat::idle_timeout,
          'overwrite_pipelines' => $filebeat::overwrite_pipelines,
          'publish_async'       => $filebeat::publish_async,
          'registry_file'       => $filebeat::registry_file,
          'shutdown_timeout'    => $filebeat::shutdown_timeout,
          'spool_size'          => $filebeat::spool_size,
        },
        'output'            => $filebeat::outputs,
        'shipper'           => $filebeat::shipper,
        'logging'           => $filebeat::logging,
        'runoptions'        => $filebeat::run_options,
        'processors'        => $filebeat::processors,
    })
    # Add the 'modules' section if supported (version >= 5.2.0)
    if versioncmp($filebeat::package_ensure, '5.2.0') >= 0 {
      $filebeat_config = deep_merge($filebeat_config_temp, { 'modules' => $filebeat::modules })
    }
    else {
      $filebeat_config = $filebeat_config_temp
    }
  }

  if 'filebeat_version' in $facts and $facts['filebeat_version'] != false {
    $skip_validation = versioncmp($facts['filebeat_version'], $filebeat::major_version) ? {
      -1      => true,
      default => false,
    }
  } else {
    $skip_validation = false
  }

  case $facts['kernel'] {
    'Linux'   : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $major_version ? {
          '5'     => "${filebeat::filebeat_path} ${filebeat::extra_validate_options} -N -configtest -c %",
          default => "${filebeat::filebeat_path} ${filebeat::extra_validate_options} -c % test config",
        },
      }

      file { 'filebeat.yml':
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

      file { 'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        owner   => $filebeat::config_dir_owner,
        group   => $filebeat::config_dir_group,
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
        notify  => Service['filebeat'],
      }
    } # end Linux

    'SunOS'   : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => '/opt/local/bin/filebeat test config -c %',
      }

      file { 'filebeat.yml':
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

      file { 'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        owner   => $filebeat::config_dir_owner,
        group   => $filebeat::config_dir_group,
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
      }
    } # end SunOS

    'FreeBSD'   : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $major_version ? {
          '5'     => "/usr/local/sbin/filebeat ${filebeat::extra_validate_options} -N -configtest -c %",
          default => "/usr/local/sbin/filebeat ${filebeat::extra_validate_options} -c % test config",
        },
      }

      file { 'filebeat.yml':
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

      file { 'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        owner   => $filebeat::config_dir_owner,
        group   => $filebeat::config_dir_group,
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
        notify  => Service['filebeat'],
      }
    } # end FreeBSD

    'OpenBSD'   : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $major_version ? {
          '5'     => "${filebeat::filebeat_path} ${filebeat::extra_validate_options} -N -configtest -c %",
          default => "${filebeat::filebeat_path} ${filebeat::extra_validate_options} -c % test config",
        },
      }

      file { 'filebeat.yml':
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

      file { 'filebeat-config-dir':
        ensure  => $filebeat::directory_ensure,
        path    => $filebeat::config_dir,
        owner   => $filebeat::config_dir_owner,
        group   => $filebeat::config_dir_group,
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
        force   => true,
        notify  => Service['filebeat'],
      }
    } # end OpenBSD

    'Windows' : {
      $cmd_install_dir = regsubst($filebeat::install_dir, '/', '\\', 'G')
      $filebeat_path = join([$cmd_install_dir, 'Filebeat', 'filebeat.exe'], '\\')

      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $major_version ? {
          /(7|8)/  => "\"${filebeat_path}\" ${filebeat::extra_validate_options} test config -c \"%\"",
          default  => "\"${filebeat_path}\" ${filebeat::extra_validate_options} -N -configtest -c \"%\"",
        }
      }

      file { 'filebeat.yml':
        ensure       => $filebeat::file_ensure,
        path         => $filebeat::config_file,
        content      => template($filebeat::conf_template),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat-config-dir'],
      }

      file { 'filebeat-config-dir':
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
