# filebeat::module::apache
#
# @summary 
#  This class manages the Filebeat module for Apache HTTP Server.
#
# @example
# class { 'filebeat::module::apache':
#   access_enabled => true,
#   access_paths   => [
#     '/var/log/apache2/access.log',
#   ],
#   error_enabled  => true,
#   error_paths    => [
#     '/var/log/apache2/error.log',
#   ],
# }
#
# @param access_enabled
#  Whether to enable the Apache access log module. Defaults to `false`.
# @param access_paths
#   An array of absolute paths to Apache access log files. Defaults to `undef`.
# @param error_enabled
#   Whether to enable the Apache error log module. Defaults to `false`.
# @param error_paths
#   An array of absolute paths to Apache error log files. Defaults to `undef`.
#
class filebeat::module::apache (
  Boolean $access_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $access_paths = undef,
  Boolean $error_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $error_paths = undef,
) {
  filebeat::module { 'apache':
    config => {
      'access' => delete_undef_values(
        {
          'enabled'   => $access_enabled,
          'var.paths' => $access_paths,
        }
      ),
      'error'  => delete_undef_values(
        {
          'enabled'   => $error_enabled,
          'var.paths' => $error_paths,
        }
      ),
    },
  }
}
