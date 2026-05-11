# filebeat::module::mysql
#
# @summary
#   This class manages the Filebeat module for MySQL.
#
# @example
# class { 'filebeat::module::mysql':
#   error_enabled => true,
#   error_paths   => [
#     '/var/log/mysql/error.log',
#   ],
#   slowlog_enabled => true,
#   slowlog_paths   => [
#     '/var/log/mysql/slow.log',
#   ],
# }
#
# @param error_enabled
#   Whether to enable the MySQL error log module. Defaults to false.
# @param error_paths
#   An array of absolute paths to the MySQL error log files. Defaults to undef.
# @param slowlog_enabled
#   Whether to enable the MySQL slow log module. Defaults to false.
# @param slowlog_paths
#   An array of absolute paths to the MySQL slow log files. Defaults to undef.
#
class filebeat::module::mysql (
  Boolean $error_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $error_paths = undef,
  Boolean $slowlog_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $slowlog_paths = undef,
) {
  filebeat::module { 'mysql':
    config => {
      'error'   => delete_undef_values(
        {
          'enabled'   => $error_enabled,
          'var.paths' => $error_paths,
        }
      ),
      'slowlog' => delete_undef_values(
        {
          'enabled'   => $slowlog_enabled,
          'var.paths' => $slowlog_paths,
        }
      ),
    },
  }
}
