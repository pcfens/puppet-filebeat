# filebeat::module::system
#
# @summary
#   This class manages the Filebeat system module.
#
# @example
#   class { 'filebeat::module::system':
#     syslog_enabled => true,
#     syslog_paths   => [
#       '/var/log/syslog',
#     ],
#     auth_enabled   => true,
#     auth_paths     => [
#       '/var/log/auth.log',
#     ],
#   }
#
# @param syslog_enabled
#   A boolean value to enable or disable the syslog module.
# @param syslog_paths
#   An optional array of paths to the syslog logs.
# @param auth_enabled
#   A boolean value to enable or disable the auth module.
# @param auth_paths
#   An optional array of paths to the auth logs.
#
class filebeat::module::system (
  Boolean $syslog_enabled = false,
  Optional[Array[Stdlib::Unixpath]] $syslog_paths = undef,
  Boolean $auth_enabled = false,
  Optional[Array[Stdlib::Unixpath]] $auth_paths = undef,
) {
  filebeat::module { 'system':
    config => {
      'syslog' => delete_undef_values(
        {
          'enabled'   => $syslog_enabled,
          'var.paths' => $syslog_paths,
        }
      ),
      'auth'   => delete_undef_values(
        {
          'enabled'   => $auth_enabled,
          'var.paths' => $auth_paths,
        }
      ),
    },
  }
}
