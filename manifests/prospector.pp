# filebeat::prospector
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   filebeat::prospector { 'namevar': }
define filebeat::prospector (
  $ensure                = present,
  $paths                 = [],
  $exclude_files         = [],
  $encoding              = 'plain',
  $input_type            = 'log',
  $fields                = {},
  $fields_under_root     = false,
  $ignore_older          = undef,
  $close_older           = undef,
  $doc_type              = 'log',
  $scan_frequency        = '10s',
  $harvester_buffer_size = 16384,
  $tail_files            = false,
  $backoff               = '1s',
  $max_backoff           = '10s',
  $backoff_factor        = 2,
  $close_inactive        = '5m',
  $close_renamed         = false,
  $close_removed         = true,
  $close_eof             = false,
  $clean_inactive        = 0,
  $clean_removed         = true,
  $close_timeout         = 0,
  $force_close_files     = false,
  $include_lines         = [],
  $exclude_lines         = [],
  $max_bytes             = '10485760',
  $multiline             = {},
  $json                  = {},
  $tags                  = [],
  $symlinks              = false,
  $pipeline              = undef,
  $processors            = [],
) {

  validate_hash($fields, $multiline, $json)
  validate_array($paths, $exclude_files, $include_lines, $exclude_lines, $tags, $processors)
  validate_bool($tail_files, $close_renamed, $close_removed, $close_eof, $clean_removed, $symlinks)

  $prospector_template = $filebeat::major_version ? {
    '5'     => 'prospector5.yml.erb',
    default => 'prospector.yml.erb',
  }

  if $::filebeat_version {
    $skip_validation = versioncmp($::filebeat_version, $filebeat::major_version) ? {
      -1      => true,
      default => false,
    }
  } else {
    $skip_validation = false
  }

  case $::kernel {
    'Linux' : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $filebeat::major_version ? {
          '5'     => "\"${filebeat::filebeat_path}\" -N -configtest -c \"%\"",
          default => "\"${filebeat::filebeat_path}\" -c \"${filebeat::config_file}\" test config",
        },
      }
      file { "filebeat-${name}":
        ensure       => $ensure,
        path         => "${filebeat::config_dir}/${name}.yml",
        owner        => 'root',
        group        => 'root',
        mode         => $::filebeat::config_file_mode,
        content      => template("${module_name}/${prospector_template}"),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        before       => File['filebeat.yml'],
      }
    }

    'FreeBSD' : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => '/usr/local/sbin/filebeat -N -configtest -c %',
      }
      file { "filebeat-${name}":
        ensure       => $ensure,
        path         => "${filebeat::config_dir}/${name}.yml",
        owner        => 'root',
        group        => 'wheel',
        mode         => $::filebeat::config_file_mode,
        content      => template("${module_name}/${prospector_template}"),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        before       => File['filebeat.yml'],
      }
    }

    'Windows' : {
      $cmd_install_dir = regsubst($filebeat::install_dir, '/', '\\', 'G')
      $filebeat_path = join([$cmd_install_dir, 'Filebeat', 'filebeat.exe'], '\\')

      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $::filebeat_version ? {
          '5'     => "\"${filebeat_path}\" -N -configtest -c \"%\"",
          default => "\"${filebeat_path}\" -c \"${filebeat::config_file}\" test config",
        },
      }

      file { "filebeat-${name}":
        ensure       => $ensure,
        path         => "${filebeat::config_dir}/${name}.yml",
        content      => template("${module_name}/${prospector_template}"),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        before       => File['filebeat.yml'],
      }
    }

    default : {
      fail($filebeat::kernel_fail_message)
    }

  }
}
