# filebeat::module::iptables
#
# @summary
#   This class manages the Filebeat iptables module.
#
# @example
#   class { 'filebeat::module::iptables':
#     log_enabled => true,
#     log_paths   => [
#       '/var/log/iptables.log',
#     ],
#     log_syslog_host => '0.0.0.0',
#     log_syslog_port => 9001,
#     log_tags => [
#       'iptables',
#       'forwarded',
#     ],
#   }
#
# @param log_enabled
#   Whether to enable the iptables module. Defaults to `false`.
# @param log_input
#   The input to use for the iptables logs. file to read from a file, syslog to listen for syslog messages.
# @param log_paths
#   An array of absolute paths to the iptables log files.
# @param log_syslog_host
#   The interface to bind to for listening for syslog messages.
# @param log_syslog_port
#   The port to listen on for syslog messages.
# @param log_tags
#   An array of tags to add to the iptables logs.
#
class filebeat::module::iptables (
  Boolean $log_enabled = false,
  Optional[Enum['file', 'syslog']] $log_input = undef,
  Optional[Array[Stdlib::Absolutepath]] $log_paths = undef,
  Optional[Stdlib::Host] $log_syslog_host = undef,
  Optional[Stdlib::Port] $log_syslog_port = undef,
  Optional[Array[String[1]]] $log_tags = undef,
) {
  filebeat::module { 'iptables':
    config => {
      'log' => delete_undef_values(
        {
          'enabled'         => $log_enabled,
          'var.input'       => $log_input,
          'var.paths'       => $log_paths,
          'var.syslog_host' => $log_syslog_host,
          'var.syslog_port' => $log_syslog_port,
          'var.tags'        => $log_tags,
        }
      ),
    },
  }
}
