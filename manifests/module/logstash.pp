# filebeat::module::logstash
#
# @summary
#   This class manages the Filebeat Logstash module.
#
# @example
#   class { 'filebeat::module::logstash':
#     log_enabled     => true,
#     log_paths       => ['/var/log/logstash/logstash-plain.log'],
#     slowlog_enabled => true,
#     slowlog_paths   => ['/var/log/logstash/logstash-slowlog.log'],
#   }
#
# @param log_enabled
#   Whether to enable the Logstash module.
# @param log_paths
#   An array of paths to the Logstash logs.
# @param slowlog_enabled
#   Whether to enable the Logstash slowlog module.
# @param slowlog_paths
#   An array of paths to the Logstash slowlogs.
#
class filebeat::module::logstash (
  Boolean $log_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $log_paths = undef,
  Boolean $slowlog_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $slowlog_paths = undef,
) {
  filebeat::module { 'logstash':
    config => {
      'log'     => delete_undef_values(
        {
          'enabled'   => $log_enabled,
          'var.paths' => $log_paths,
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
