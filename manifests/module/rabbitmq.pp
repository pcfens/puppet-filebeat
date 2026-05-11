# filebeat::module::rabbitmq
#
# @summary
#   This class manages the Filebeat RabbitMQ module.
#
# @example
#   class { 'filebeat::module::rabbitmq':
#     log_enabled => true,
#     log_paths   => ['/var/log/rabbitmq/*.log'],
#   }
#
# @param log_enabled
#   Whether to enable the RabbitMQ module.
# @param log_paths
#   An array of paths to the RabbitMQ log files.
#
class filebeat::module::rabbitmq (
  Boolean $log_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $log_paths = undef,
) {
  filebeat::module { 'rabbitmq':
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
