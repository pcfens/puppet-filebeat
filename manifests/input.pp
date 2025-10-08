# filebeat::input
#
# Defines a filebeat input configuration for collecting log data from various sources
#
# @summary Manages filebeat input configurations for log collection
#
# @example Basic file input
#   filebeat::input { 'apache-logs':
#     paths => ['/var/log/apache2/*.log'],
#     doc_type => 'apache',
#   }
#
# @example Docker container input
#   filebeat::input { 'docker-logs':
#     input_type => 'docker',
#     containers_ids => ['*'],
#     containers_path => '/var/lib/docker/containers',
#   }
#
# @param ensure
#   Whether the input should be present or absent (default: present)
#
# @param paths
#   List of paths to read log files from
#
# @param exclude_files
#   List of regular expressions to match files that should be excluded
#
# @param containers_ids
#   List of container IDs to read logs from (default: ['*'])
#
# @param containers_path
#   Path to the container logs directory (default: /var/lib/docker/containers)
#
# @param containers_stream
#   Stream to read from containers: all, stdout, or stderr (default: all)
#
# @param combine_partial
#   Whether to combine partial messages from containers (default: false)
#
# @param syslog_protocol
#   Protocol to use for syslog input: tcp or udp (default: udp)
#
# @param syslog_host
#   Host and port to listen on for syslog input (default: localhost:5140)
#
# @param cri_parse_flags
#   Whether to parse CRI flags (default: false)
#
# @param encoding
#   The file encoding to use (default: plain)
#
# @param input_type
#   The type of input (e.g., log, stdin, docker, syslog)
#
# @param take_over
#   Whether this input should take over from a previous input
#
# @param fields
#   Optional fields to add to each event
#
# @param fields_under_root
#   Whether to store custom fields at the root level instead of under 'fields'
#
# @param ssl
#   SSL configuration options
#
# @param ignore_older
#   Ignore files that haven't been modified since this duration
#
# @param close_older
#   Close file handles for files that haven't been modified since this duration
#
# @param doc_type
#   The document type to set for events (default: log)
#
# @param scan_frequency
#   How often to scan for new files (default: 10s)
#
# @param harvester_buffer_size
#   The buffer size for each harvester (default: 16384)
#
# @param harvester_limit
#   Maximum number of harvesters that can be started in parallel
#
# @param tail_files
#   Whether to start reading new files at the end instead of the beginning (default: false)
#
# @param backoff
#   How long to wait before checking a file again after EOF (default: 1s)
#
# @param max_backoff
#   Maximum backoff time (default: 10s)
#
# @param backoff_factor
#   Factor by which backoff increases (default: 2)
#
# @param close_inactive
#   Close file handle after this period of inactivity (default: 5m)
#
# @param close_renamed
#   Close file handles when files are renamed (default: false)
#
# @param close_removed
#   Close file handles when files are removed (default: true)
#
# @param close_eof
#   Close file handles as soon as EOF is reached (default: false)
#
# @param clean_inactive
#   Remove state for files that haven't been modified for this duration (default: 0)
#
# @param clean_removed
#   Remove state for files that have been removed from disk (default: true)
#
# @param close_timeout
#   Close file handles after this timeout (default: 0)
#
# @param force_close_files
#   Force close files on shutdown (default: false)
#
# @param include_lines
#   List of regular expressions to match lines that should be included
#
# @param exclude_lines
#   List of regular expressions to match lines that should be excluded
#
# @param max_bytes
#   Maximum number of bytes a single log message can have (default: 10485760)
#
# @param multiline
#   Multiline configuration options
#
# @param json
#   JSON parsing configuration options
#
# @param tags
#   List of tags to add to each event
#
# @param symlinks
#   Whether to follow symlinks (default: false)
#
# @param pipeline
#   Ingest pipeline to use for processing
#
# @param parsers
#   List of parsers to apply to the input
#
# @param processors
#   List of processors to apply to events
#
# @param pure_array
#   Internal flag for array-based input configuration (default: false)
#
# @param host
#   Host to connect to for certain input types (default: localhost:9000)
#
# @param keep_null
#   Whether to keep null values in JSON (default: false)
#
# @param include_matches
#   List of regular expressions to match events that should be included
#
# @param seek
#   Where to start reading files: head, tail, or cursor
#
# @param max_message_size
#   Maximum size of a single message
#
# @param index
#   Elasticsearch index to write to
#
# @param publisher_pipeline_disable_host
#   Whether to disable the host field in the publisher pipeline (default: false)
#
define filebeat::input (
  Enum['absent', 'present'] $ensure        = present,
  Array[String] $paths                     = [],
  Array[String] $exclude_files             = [],
  Array[String] $containers_ids            = ["'*'"],
  String $containers_path                  = '/var/lib/docker/containers',
  String $containers_stream                = 'all',
  Boolean $combine_partial                 = false,
  Enum['tcp', 'udp'] $syslog_protocol      = 'udp',
  String $syslog_host                      = 'localhost:5140',
  Boolean $cri_parse_flags                 = false,
  String $encoding                         = 'plain',
  String $input_type                       = $filebeat::params::default_input_type,
  Optional[Boolean] $take_over             = undef,
  Hash $fields                             = {},
  Boolean $fields_under_root               = $filebeat::fields_under_root,
  Hash $ssl                                = {},
  Optional[String] $ignore_older           = undef,
  Optional[String] $close_older            = undef,
  String $doc_type                         = 'log',
  String $scan_frequency                   = '10s',
  Integer $harvester_buffer_size           = 16384,
  Optional[Integer] $harvester_limit       = undef,
  Boolean $tail_files                      = false,
  String $backoff                          = '1s',
  String $max_backoff                      = '10s',
  Integer $backoff_factor                  = 2,
  String $close_inactive                   = '5m',
  Boolean $close_renamed                   = false,
  Boolean $close_removed                   = true,
  Boolean $close_eof                       = false,
  Variant[String, Integer] $clean_inactive = 0,
  Boolean $clean_removed                   = true,
  Variant[Integer,String] $close_timeout   = 0,
  Boolean $force_close_files               = false,
  Array[String] $include_lines             = [],
  Array[String] $exclude_lines             = [],
  String $max_bytes                        = '10485760',
  Hash $multiline                          = {},
  Hash $json                               = {},
  Array[String] $tags                      = [],
  Boolean $symlinks                        = false,
  Optional[String] $pipeline               = undef,
  Array $parsers                           = [],
  Array $processors                        = [],
  Boolean $pure_array                      = false,
  String $host                             = 'localhost:9000',
  Boolean $keep_null                       = false,
  Array[String] $include_matches           = [],
  Optional[Enum['head', 'tail', 'cursor']] $seek = undef,
  Optional[String] $max_message_size       = undef,
  Optional[String] $index                  = undef,
  Boolean $publisher_pipeline_disable_host = false,
) {
  if 'filebeat_version' in $facts and $facts['filebeat_version'] != false {
    if versioncmp($facts['filebeat_version'], '6') > 0 {
      $input_template = 'input.yml.erb'
    } else {
      $input_template = 'prospector.yml.erb'
    }

    $skip_validation = versioncmp($facts['filebeat_version'], $filebeat::major_version) ? {
      -1      => true,
      default => false,
    }
  } else {
    $input_template = 'input.yml.erb'
    $skip_validation = false
  }

  case $facts['kernel'] {
    'Linux', 'OpenBSD' : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $filebeat::major_version ? {
          '5'     => "${filebeat::filebeat_path} -N -configtest -c %",
          default => "${filebeat::filebeat_path} -c ${filebeat::config_file} test config",
        },
      }
      file { "filebeat-${name}":
        ensure       => $ensure,
        path         => "${filebeat::config_dir}/${name}.yml",
        owner        => 'root',
        group        => '0',
        mode         => $filebeat::config_file_mode,
        content      => template("${module_name}/${input_template}"),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat.yml'],
      }
    }

    'SunOS' : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => "${filebeat::filebeat_path} -c ${filebeat::config_file} test config",
      }
      file { "filebeat-${name}":
        ensure       => $ensure,
        path         => "${filebeat::config_dir}/${name}.yml",
        owner        => 'root',
        group        => 'root',
        mode         => $filebeat::config_file_mode,
        content      => template("${module_name}/${input_template}"),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat.yml'],
      }
    }

    'FreeBSD' : {
      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $filebeat::major_version ? {
          '5'     => '/usr/local/sbin/filebeat -N -configtest -c %',
          default => "/usr/local/sbin/filebeat -c ${filebeat::config_file} test config",
        },
      }
      file { "filebeat-${name}":
        ensure       => $ensure,
        path         => "${filebeat::config_dir}/${name}.yml",
        owner        => 'root',
        group        => 'wheel',
        mode         => $filebeat::config_file_mode,
        content      => template("${module_name}/${input_template}"),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat.yml'],
      }
    }

    'Windows' : {
      $cmd_install_dir = regsubst($filebeat::install_dir, '/', '', 'G')
      $filebeat_path = join([$cmd_install_dir, 'Filebeat', 'filebeat.exe'], '')

      $validate_cmd = ($filebeat::disable_config_test or $skip_validation) ? {
        true    => undef,
        default => $facts['filebeat_version'] ? {
          '5'     => "${filebeat_path} -N -configtest -c %",
          default => "${filebeat_path} -c ${filebeat::config_file} test config",
        },
      }

      file { "filebeat-${name}":
        ensure       => $ensure,
        path         => "${filebeat::config_dir}/${name}.yml",
        content      => template("${module_name}/${input_template}"),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat.yml'],
      }
    }

    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
