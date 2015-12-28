define filebeat::prospector (
  $ensure                = present,
  $paths                 = [],
  $encoding              = 'plain',
  $input_type            = 'log',
  $fields                = {},
  $fields_under_root     = false,
  $ignore_older          = '24h',
  $log_type              = 'log',
  $scan_frequency        = '10s',
  $harvester_buffer_size = 16384,
  $tail_files            = false,
  $backoff               = '1s',
  $max_backoff           = '10s',
  $backoff_factor        = 2,
  $partial_line_waiting  = '5s',
  $force_close_files     = false,
) {

  case $::kernel {
    'Linux' : {
      file { "filebeat-${name}":
        ensure  => $ensure,
        path    => "${filebeat::config_dir}/${name}.yml",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
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
      fail($fail_message)
    }
  }
}
