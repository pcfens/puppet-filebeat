# filebeat::module::postgresql
#
# @summary
#   This class manages the Filebeat module for PostgreSQL.
#
# @example
#   class { 'filebeat::module::postgresql':
#     log_enabled => true,
#     log_paths   => [
#       '/var/log/postgresql/*.log',
#     ],
#   }
#
# @param log_enabled
#   Whether to enable the PostgreSQL module.
# @param log_paths
#   An array of absolute paths to the PostgreSQL log files.
#
class filebeat::module::postgresql (
  Boolean $log_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $log_paths = undef,
) {
  filebeat::module { 'postgresql':
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
