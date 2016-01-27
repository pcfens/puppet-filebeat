# This class defines a prospector portion of the filebeat
# configuration.
#
# filebeat::prospector { 'example' :
#   paths => [
#     '/var/log/syslog',
#   ]
#   fields => {
#     ipaddress => ${::ipaddress},
#   }
#   log_type => 'syslog',
# }
#
# Definitions of all parameters can be found at:
# https://www.elastic.co/guide/en/beats/filebeat/master/filebeat-configuration-details.html#configuration-filebeat-options
#
# Note: log_type is equivalent to document_type in the documentation
#
define filebeat::prospector (
  $ensure                = present,
  $paths                 = [],
  $encoding              = 'plain',
  $input_type            = 'log',
  $exclude_lines         = [],
  $include_lines         = [],
  $exclude_files         = [],
  $fields                = {},
  $fields_under_root     = false,
  $ignore_older          = '24h',
  $log_type              = undef,
  $doc_type              = 'log',
  $scan_frequency        = '10s',
  $harvester_buffer_size = 16384,
  $max_bytes             = 10485760,
  $multiline             = {},
  $tail_files            = false,
  $backoff               = '1s',
  $max_backoff           = '10s',
  $backoff_factor        = 2,
  $partial_line_waiting  = '5s',
  $force_close_files     = false,
  $spool_size            = 1024,
  $publish_async         = false,
  $idle_timeout          = '5s',
  $registry_file         = '.filebeat',
) {

  if $log_type {
    warning('log_type is deprecated, and will be removed prior to a v1.0 release so parameters match the filebeat documentation - use doc_type instead')
    $real_doc_type = $log_type
  } else {
    $real_doc_type = $doc_type
  }
  validate_array($paths)
  validate_array($exclude_lines)
  validate_array($include_lines)
  validate_array($exclude_files)
  validate_hash($fields)
  validate_hash($multiline)

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
