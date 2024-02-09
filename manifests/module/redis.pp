# filebeat::module::redis
#
# @summary
#   This class manages the Filebeat Redis module.
#
# @example
#   class { 'filebeat::module::redis':
#     log_enabled      => true,
#     log_paths        => ['/var/log/redis/redis-server.log'],
#     slowlog_enabled  => true,
#     slowlog_hosts    => ['localhost:6379'],
#     slowlog_password => 'password',
#   }
#
# @param log_enabled
#   Whether to enable the Redis log input. Defaults to `false`.
# @param log_paths
#   The paths to the Redis log files. Defaults to `undef`.
# @param slowlog_enabled
#   Whether to enable the Redis slowlog input. Defaults to `false`.
# @param slowlog_hosts
#   The Redis hosts to connect to. Defaults to `undef`.
# @param slowlog_password
#   The password to use when connecting to Redis. Defaults to `undef`.
#
class filebeat::module::redis (
  Boolean $log_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $log_paths = undef,
  Boolean $slowlog_enabled = false,
  Optional[Array[String[1]]] $slowlog_hosts = undef,
  Optional[String[1]] $slowlog_password = undef,
) {
  filebeat::module { 'redis':
    config => {
      'log'     => delete_undef_values(
        {
          'enabled'   => $log_enabled,
          'var.paths' => $log_paths,
        }
      ),
      'slowlog' => delete_undef_values(
        {
          'enabled'      => $slowlog_enabled,
          'var.hosts'    => $slowlog_hosts,
          'var.password' => $slowlog_password,
        }
      ),
    },
  }
}
