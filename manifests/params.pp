# filebeat::params
#
# Set a number of default parameters
#
# @summary Set a bunch of default parameters
class filebeat::params {
  $service_ensure       = running
  $service_enable       = true
  $spool_size           = 2048
  $idle_timeout         = '5s'
  $publish_async        = false
  $shutdown_timeout     = '0'
  $beat_name            = $::fqdn
  $tags                 = []
  $queue_size           = 1000
  $max_procs            = undef
  $config_file_mode     = '0644'
  $config_dir_mode      = '0755'
  $purge_conf_dir       = true
  $fields               = {}
  $fields_under_root    = false
  $outputs              = {}
  $shipper              = {}
  $logging              = {}
  $config_hash          = {}
  $run_options          = {}
  $kernel_fail_message  = "${::kernel} is not supported by filebeat."
  $conf_template        = "${module_name}/pure_hash.yml.erb"
  $disable_config_test  = false

  # These are irrelevant as long as the template is set based on the major_version parameter
  # if versioncmp('1.9.1', $::rubyversion) > 0 {
  #   $conf_template = "${module_name}/filebeat.yml.ruby18.erb"
  # } else {
  #   $conf_template = "${module_name}/filebeat.yml.erb"
  # }
  #

  # Archlinux has a proper package in the official repos
  # we shouldn't manage the repo on it
  case $facts['os']['family'] {
    'Archlinux': {
      $manage_repo = false
      $filebeat_path = '/usr/bin/filebeat'
      $major_version = '6'
    }
    default: {
      $manage_repo = true
      $filebeat_path = '/usr/share/filebeat/bin/filebeat'
      $major_version = '5'
    }
  }
  case $::kernel {
    'Linux'   : {
      $package_ensure    = present
      $config_file       = '/etc/filebeat/filebeat.yml'
      $config_dir        = '/etc/filebeat/conf.d'
      $config_file_owner = 'root'
      $config_file_group = 'root'
      $config_dir_owner  = 'root'
      $config_dir_group  = 'root'
      $registry_file     = '/var/lib/filebeat/registry'

      # These parameters are ignored if/until tarball installs are supported in Linux
      $tmp_dir         = '/tmp'
      $install_dir     = undef
      case $::osfamily {
        'RedHat': {
          $service_provider = 'redhat'
        }
        default: {
          $service_provider = undef
        }
      }
      $url_arch        = undef
    }

    'FreeBSD': {
      $package_ensure    = present
      $config_file       = '/usr/local/etc/filebeat.yml'
      $config_dir        = '/usr/local/etc/filebeat.d'
      $config_file_owner = 'root'
      $config_file_group = 'wheel'
      $config_dir_owner  = 'root'
      $config_dir_group  = 'wheel'
      $registry_file     = '/var/lib/filebeat/registry'
      $tmp_dir           = '/tmp'
      $service_provider  = undef
      $install_dir       = undef
      $url_arch          = undef
    }

    'Windows' : {
      $package_ensure   = '5.6.2'
      $config_file_owner = 'Administrator'
      $config_file_group = undef
      $config_dir_owner = 'Administrator'
      $config_dir_group = undef
      $config_file      = 'C:/Program Files/Filebeat/filebeat.yml'
      $config_dir       = 'C:/Program Files/Filebeat/conf.d'
      $registry_file    = 'C:/ProgramData/filebeat/registry'
      $install_dir      = 'C:/Program Files'
      $tmp_dir          = 'C:/Windows/Temp'
      $service_provider = undef
      $url_arch         = $::architecture ? {
        'x86'   => 'x86',
        'x64'   => 'x86_64',
        default => fail("${::architecture} is not supported by filebeat."),
      }
    }

    default : {
      fail($kernel_fail_message)
    }
  }
}
