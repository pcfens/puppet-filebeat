# filebeat::module::sophos
#
# @summary
#   This class manages the Filebeat Sophos module.
#
# @example
#   class { 'filebeat::module::sophos':
#     xg_enabled => true,
#     xg_input => 'udp',
#     xg_syslog_host => '0.0.0.0',
#     xg_syslog_port => 514,
#     xg_host_name => 'sophos-xg',
#   }
#
# @param xg_enabled
#   Whether to enable the Sophos XG module.
# @param xg_paths
#   An array of paths to the Sophos XG logs.
# @param xg_input
#   The input type for the Sophos XG module. tcp or udp for syslog input, file for log files.
# @param xg_syslog_host
#   Interface to listen to for syslog input.
# @param xg_syslog_port
#   Port to listen on for syslog input.
# @param xg_host_name
#   Host name / Observer name, since SophosXG does not provide this in the syslog file. 
# @param utm_enabled
#   Whether to enable the Sophos UTM module.
# @param utm_paths
#   An array of paths to the Sophos UTM logs.
# @param utm_input
#   The input type for the Sophos UTM module. tcp or udp for syslog input, file for log files.
# @param utm_syslog_host
#   Interface to listen to for syslog input.
# @param utm_syslog_port
#   Port to listen on for syslog input.
# @param utm_tz_offset
#   Timezone offset. If the logs are in a different timezone than the Filebeat host, set this to the timezone offset.
# @param utm_rsa_fields
#   Flag to control whether non-ECS fields are added to the event.
# @param utm_keep_raw_fields
#   Flag to control the addition of the raw parser fields to the event.
#
class filebeat::module::sophos (
  Boolean $xg_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $xg_paths = undef,
  Optional[Enum['udp', 'tcp','file']] $xg_input = undef,
  Optional[Stdlib::Host] $xg_syslog_host = undef,
  Optional[Stdlib::Port] $xg_syslog_port = undef,
  Optional[Stdlib::Host] $xg_host_name = undef,
  Boolean $utm_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $utm_paths = undef,
  Optional[Enum['udp', 'tcp','file']] $utm_input = undef,
  Optional[Stdlib::Host] $utm_syslog_host = undef,
  Optional[Stdlib::Port] $utm_syslog_port = undef,
  Optional[Pattern[/^[-+]\d{2}:\d{2}$/]] $utm_tz_offset = undef,
  Optional[Boolean] $utm_rsa_fields = undef,
  Optional[Boolean] $utm_keep_raw_fields = undef,
) {
  filebeat::module { 'sophos':
    config => {
      'xg'  => delete_undef_values(
        {
          'enabled'         => $xg_enabled,
          'var.input'       => $xg_input,
          'var.paths'       => $xg_paths,
          'var.syslog_host' => $xg_syslog_host,
          'var.syslog_port' => $xg_syslog_port,
          'var.host_name'   => $xg_host_name,
        }
      ),
      'utm' => delete_undef_values(
        {
          'enabled'             => $utm_enabled,
          'var.input'           => $utm_input,
          'var.paths'           => $utm_paths,
          'var.syslog_host'     => $utm_syslog_host,
          'var.syslog_port'     => $utm_syslog_port,
          'var.tz_offset'       => $utm_tz_offset,
          'var.rsa_fields'      => $utm_rsa_fields,
          'var.keep_raw_fields' => $utm_keep_raw_fields,
        }
      ),
    },
  }
}
