# filebeat::module::auditd
#
# @summary
#   This class manages the Filebeat module for auditd.
#
# @example
#   class { 'filebeat::module::auditd':
#     log_enabled => true,
#     log_paths   => [
#       '/var/log/audit/audit.log',
#     ],
#   }
#
# @param log_enabled
#   Whether to enable the auditd module.
# @param log_paths
#   An array of absolute paths to the auditd log files.
#
class filebeat::module::auditd (
  Boolean $log_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $log_paths = undef,
) {
  filebeat::module { 'auditd':
    config => {
      'log' => delete_undef_values(
        {
          'enabled'   => $log_enabled,
          'var.paths' => $log_paths,
        }
      ),
    },
  }
}
