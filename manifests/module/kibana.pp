# filebeat::module::kibana
#
# @summary
#   This class manages the Filebeat Kibana module.
#
# @example
#   class { 'filebeat::module::kibana':
#     log_enabled  => true,
#     log_paths    => ['/var/log/kibana.log'],
#     audit_enabled => true,
#     audit_paths   => ['/var/log/kibana-audit.log'],
#   }
#
# @param log_enabled
#   Whether to enable the Kibana log input. Defaults to `false`.
# @param log_paths
#   An array of absolute paths to the Kibana log files.
# @param audit_enabled
#   Whether to enable the Kibana audit input. Defaults to `false`.
# @param audit_paths
#   An array of absolute paths to the Kibana audit log files.
#
class filebeat::module::kibana (
  Boolean $log_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $log_paths = undef,
  Boolean $audit_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $audit_paths = undef,
) {
  filebeat::module { 'kibana':
    config => {
      'log'   => delete_undef_values(
        {
          'enabled'   => $log_enabled,
          'var.paths' => $log_paths,
        }
      ),
      'audit' => delete_undef_values(
        {
          'enabled'   => $audit_enabled,
          'var.paths' => $audit_paths,
        }
      ),
    },
  }
}
