# filebeat::module::elasticsearch
#
# @summary
#   This class manages the filebeat module for elasticsearch.
#
# @example
#   class { 'filebeat::module::elasticsearch':
#     server_enabled => true,
#     server_paths   => ['/var/log/elasticsearch/*.log'],
#     gc_enabled     => true,
#     gc_paths       => ['/var/log/elasticsearch/gc.log*'],
#     audit_enabled  => true,
#     audit_paths    => ['/var/log/elasticsearch/audit.log*'],
#     deprecation_enabled => true,
#     deprecation_paths   => ['/var/log/elasticsearch/deprecation.log*'],
#     slowlog_enabled => true,
#     slowlog_paths   => ['/var/log/elasticsearch/*_index_search_slowlog.log'],
#   }
#
# @param server_enabled
#   Boolean to enable or disable the server log. Defaults to false.
# @param server_paths
#   Array of absolute paths to the server log files. Defaults to undef.
# @param gc_enabled
#   Boolean to enable or disable the garbage collection log. Defaults to false.
# @param gc_paths
#   Array of absolute paths to the garbage collection log files. Defaults to undef.
# @param audit_enabled
#   Boolean to enable or disable the audit log. Defaults to false.
# @param audit_paths
#   Array of absolute paths to the audit log files. Defaults to undef.
# @param deprecation_enabled
#   Boolean to enable or disable the deprecation log. Defaults to false.
# @param deprecation_paths
#   Array of absolute paths to the deprecation log files. Defaults to undef.
# @param slowlog_enabled
#   Boolean to enable or disable the slow log. Defaults to false.
# @param slowlog_paths
#   Array of absolute paths to the slow log files. Defaults to undef.
#
class filebeat::module::elasticsearch (
  Boolean $server_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $server_paths = undef,
  Boolean $gc_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $gc_paths = undef,
  Boolean $audit_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $audit_paths = undef,
  Boolean $deprecation_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $deprecation_paths = undef,
  Boolean $slowlog_enabled = false,
  Optional[Array[Stdlib::Absolutepath]] $slowlog_paths = undef,
) {
  filebeat::module { 'elasticsearch':
    config => {
      'server'      => delete_undef_values(
        {
          'enabled'   => $server_enabled,
          'var.paths' => $server_paths,
        }
      ),
      'gc'          => delete_undef_values(
        {
          'enabled'   => $gc_enabled,
          'var.paths' => $gc_paths,
        }
      ),
      'audit'       => delete_undef_values(
        {
          'enabled'   => $audit_enabled,
          'var.paths' => $audit_paths,
        }
      ),
      'deprecation' => delete_undef_values(
        {
          'enabled'   => $deprecation_enabled,
          'var.paths' => $deprecation_paths,
        }
      ),
      'slowlog'     => delete_undef_values(
        {
          'enabled'   => $slowlog_enabled,
          'var.paths' => $slowlog_paths,
        }
      ),
    },
  }
}
