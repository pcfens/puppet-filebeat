# This class installs the Elastic filebeat log shipper and
# helps manage which files are shipped
#
# @example
# class { 'filebeat':
#   outputs => {
#     'logstash' => {
#       'hosts' => [
#         'localhost:5044',
#       ],
#     },
#   },
# }
#
# @param package_ensure [String] The ensure parameter for the filebeat package (default: present)
# @param manage_repo [Boolean] Whether or not the upstream (elastic) repo should be configured or not (default: true)
# @param service_ensure [String] The ensure parameter on the filebeat service (default: running)
# @param service_enable [String] The enable parameter on the filebeat service (default: true)
# @param spool_size [Integer] How large the spool should grow before being flushed to the network (default: 1024)
# @param idle_timeout [String] How often the spooler should be flushed even if spool size isn't reached (default: 5s)
# @param registry_file [String] The registry file used to store positions, absolute or relative to working directory (default .filebeat)
# @param config_dir [String] The directory where prospectors should be defined (default: /etc/filebeat/conf.d)
# @param purge_conf_dir [Boolean] Should files in the prospector configuration directory not managed by puppet be automatically purged
# @param outputs [Hash] Will be converted to YAML for the required outputs section of the configuration (see documentation, and above)
# @param shipper [Hash] Will be converted to YAML to create the optional shipper section of the filebeat config (see documentation)
# @param logging [Hash] Will be converted to YAML to create the optional logging section of the filebeat config (see documentation)
# @param prospectors [Hash] Prospectors that will be created. Commonly used to create prospectors using hiera
class filebeat (
  $package_ensure = $filebeat::params::package_ensure,
  $manage_repo    = $filebeat::params::manage_repo,
  $service_ensure = $filebeat::params::service_ensure,
  $service_enable = $filebeat::params::service_enable,
  $spool_size     = $filebeat::params::spool_size,
  $idle_timeout   = $filebeat::params::idle_timeout,
  $registry_file  = $filebeat::params::registry_file,
  $config_dir     = $filebeat::params::config_dir,
  $purge_conf_dir = $filebeat::params::purge_conf_dir,
  $outputs        = $filebeat::params::outputs,
  $shipper        = $filebeat::params::shipper,
  $logging        = $filebeat::params::logging,
  $prospectors    = {},
) inherits filebeat::params {

  validate_bool($manage_repo)
  validate_hash($outputs, $logging, $prospectors)
  validate_string($idle_timeout, $registry_file, $config_dir, $package_ensure)

  anchor { 'filebeat::begin': } ->
  class { 'filebeat::package': } ->
  class { 'filebeat::config': } ->
  class { 'filebeat::service': } ->
  anchor { 'filebeat::end':}

  if $manage_repo {
    include filebeat::repo

    Anchor['filebeat::begin'] ->
    Class['filebeat::repo'] ->
    Class['filebeat::package']
  }

  if !empty($prospectors) {
    create_resources('filebeat::prospector', $prospectors)
  }
}
