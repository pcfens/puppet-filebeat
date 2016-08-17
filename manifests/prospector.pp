define filebeat::prospector (
  $ensure                = present,
  $input_type            = 'log',
  $paths                 = [],
  $encoding              = 'plain',
  $exclude_lines         = [],
  $include_lines         = [],
  $exclude_files         = [],
  $fields                = {},
  $fields_under_root     = false,
  $ignore_older          = undef,
  $scan_frequency        = '10s',
  $doc_type              = 'log',
  $harvester_buffer_size = 16384,
  $max_bytes             = '10485760',
  $multiline             = {},
  $tail_files            = false,
  $backoff               = '1s',
  $max_backoff           = '10s',
  $backoff_factor        = 2,

  # v1.2 settings
  $close_older           = undef,
  $log_type              = undef,
  $partial_line_waiting  = '5s',
  $force_close_files     = false,

  # v5 settings
  $tags                  = [],
  $close_inactive        = '1h',
  $close_renamed         = undef,
  $close_removed         = undef,
  $close_eof             = undef,
  $clean_inactive        = undef,
  $clean_removed         = undef,
  $json                  = {},

) {

  validate_hash($fields, $json, $multiline)
  validate_array($paths, $exclude_files, $include_lines, $exclude_lines, $tags)

  if $log_type {
    warning('log_type is deprecated, and will be removed prior to a v1.0 release so parameters match the filebeat documentation - use doc_type instead')
    $real_doc_type = $log_type
  } else {
    $real_doc_type = $doc_type
  }

  if versioncmp($::filebeat::version, '5') < 0 {
    $_version = '.v1'
  } else {
    $_version = ''
  }

  case $::kernel {
    'Linux' : {
      file { "filebeat-${name}":
        ensure  => $ensure,
        path    => "${filebeat::config_dir}/${name}.yml",
        owner   => 'root',
        group   => 'root',
        mode    => $::filebeat::config_file_mode,
        content => template("${module_name}/prospector.yml${_version}.erb"),
        notify  => Service['filebeat'],
      }
    }
    'Windows' : {
      file { "filebeat-${name}":
        ensure  => $ensure,
        path    => "${filebeat::config_dir}/${name}.yml",
        content => template("${module_name}/prospector.yml${_version}.erb"),
        notify  => Service['filebeat'],
      }
    }
    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
