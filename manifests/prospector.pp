define filebeat::prospector (
  $ensure                = hiera('filebeat::prospector::ensure', present),
  $paths                 = hiera('filebeat::prospector::paths', []),
  $exclude_files         = hiera('filebeat::prospector::exclude_files', []),
  $encoding              = hiera('filebeat::prospector::encoding', 'plain'),
  $input_type            = hiera('filebeat::prospector::input_type', 'log'),
  $fields                = hiera('filebeat::prospector::fields', {}),
  $fields_under_root     = hiera('filebeat::prospector::fields_under_root', false),
  $ignore_older          = hiera('filebeat::prospector::ignore_older', '0'),
  $close_older           = hiera('filebeat::prospector::close_older', '1h'),
  $log_type              = hiera('filebeat::prospector::log_type', undef),
  $doc_type              = hiera('filebeat::prospector::doc_type', 'log'),
  $scan_frequency        = hiera('filebeat::prospector::scan_frequency', '10s'),
  $harvester_buffer_size = hiera('filebeat::prospector::harvester_buffer_size', 16384),
  $tail_files            = hiera('filebeat::prospector::tail_files', false),
  $backoff               = hiera('filebeat::prospector::backoff', '1s'),
  $max_backoff           = hiera('filebeat::prospector::max_backoff', '10s'),
  $backoff_factor        = hiera('filebeat::prospector::backoff_factor', 2),
  $force_close_files     = hiera('filebeat::prospector::force_close_files', false),
  $include_lines         = hiera('filebeat::prospector::include_lines', []),
  $exclude_lines         = hiera('filebeat::prospector::exclude_lines', []),
  $max_bytes             = hiera('filebeat::prospector::max_bytes', '10485760'),
  $multiline             = hiera('filebeat::prospector::multiline', {}),
) {

  validate_hash($fields, $multiline)
  validate_array($paths, $exclude_files, $include_lines, $exclude_lines)

  if $log_type {
    warning('log_type is deprecated, and will be removed prior to a v1.0 release so parameters match the filebeat documentation - use doc_type instead')
    $real_doc_type = $log_type
  } else {
    $real_doc_type = $doc_type
  }

  case $::kernel {
    'Linux' : {
      file { "filebeat-${name}":
        ensure  => $ensure,
        path    => "${filebeat::config_dir}/${name}.yml",
        owner   => 'root',
        group   => 'root',
        mode    => $::filebeat::config_file_mode,
        content => template("${module_name}/prospector.yml.erb"),
        notify  => Service['filebeat'],
      }
    }
    'Windows' : {
      file { "filebeat-${name}":
        ensure  => $ensure,
        path    => "${filebeat::config_dir}/${name}.yml",
        content => template("${module_name}/prospector.yml.erb"),
        notify  => Service['filebeat'],
      }
    }
    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
