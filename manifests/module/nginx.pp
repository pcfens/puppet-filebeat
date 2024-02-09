# filebeat::module::nginx
#
# @summary
#   This class manages the Filebeat module for Nginx.
#
# @example
#   class { 'filebeat::module::nginx':
#     access_enabled => true,
#     access_paths   => [
#       '/var/log/nginx/access.log*',
#     ],
#     error_enabled  => true,
#     error_paths    => [
#       '/var/log/nginx/error.log*',
#     ],
#     ingress_enabled => true,
#     ingress_paths   => [
#       '/var/log/nginx/ingress.log*',
#     ],
#   }
#
# @param access_enabled
#   Whether to enable the Nginx access module.
# @param access_paths
#   The paths to the Nginx access logs.
# @param error_enabled
#   Whether to enable the Nginx error module.
# @param error_paths
#   The paths to the Nginx error logs.
# @param ingress_controller_enabled
#   Whether to enable the Nginx ingress_controller module.
# @param ingress_controller_paths
#   The paths to the Nginx ingress_controller logs.
#
class filebeat::module::nginx (
  Boolean $access_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $access_paths = undef,
  Boolean $error_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $error_paths = undef,
  Boolean $ingress_controller_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $ingress_controller_paths = undef,
) {
  filebeat::module { 'nginx':
    config => {
      'access'             => delete_undef_values(
        {
          'enabled'   => $access_enabled,
          'var.paths' => $access_paths,
        }
      ),
      'error'              => delete_undef_values(
        {
          'enabled'   => $error_enabled,
          'var.paths' => $error_paths,
        }
      ),
      'ingress_controller' => delete_undef_values(
        {
          'enabled'   => $ingress_controller_enabled,
          'var.paths' => $ingress_controller_paths,
        }
      ),
    },
  }
}
