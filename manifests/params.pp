# filebeat::params
#
# Set a number of default parameters
#
# @summary Set a bunch of default parameters
class filebeat::params {
  $manage_package                 = true
  $service_ensure                 = running
  $service_enable                 = true
  $spool_size                     = 2048
  $idle_timeout                   = '5s'
  $publish_async                  = false
  $shutdown_timeout               = '0'
  $beat_name                      = $facts['networking']['fqdn']
  $tags                           = []
  $max_procs                      = undef
  $config_file_mode               = '0644'
  $config_dir_mode                = '0755'
  $purge_conf_dir                 = true
  $enable_conf_modules            = false
  $fields                         = {}
  $fields_under_root              = false
  $ssl                            = {}
  $http                           = {}
  $cloud                          = {}
  $features                       = {}
  $queue                          = {}
  $outputs                        = {}
  $shipper                        = {}
  $logging                        = {}
  $autodiscover                   = {}
  $run_options                    = {}
  $modules                        = []
  $overwrite_pipelines            = false
  $kernel_fail_message            = "${facts['kernel']} is not supported by filebeat."
  $osfamily_fail_message          = "${facts['os']['family']} is not supported by filebeat."
  $conf_template                  = "${module_name}/pure_hash.yml.erb"
  $disable_config_test            = false
  $xpack                          = undef
  $systemd_override_dir           = '/etc/systemd/system/filebeat.service.d'
  $systemd_beat_log_opts_template = "${module_name}/systemd/logging.conf.erb"
  $registry_path                  = '/var/lib/filebeat'
  $registry_file_permissions      = '0600'
  $registry_flush                 = '0s'

  # These are irrelevant as long as the template is set based on the major_version parameter
  # if versioncmp('1.9.1', $::rubyversion) > 0 {
  #   $conf_template = "${module_name}/filebeat.yml.ruby18.erb"
  # } else {
  #   $conf_template = "${module_name}/filebeat.yml.erb"
  # }
  #

  # Archlinux and OpenBSD have proper packages in the official repos
  # we shouldn't manage the repo on them
  case $facts['os']['family'] {
    'Archlinux': {
      $manage_repo = false
      $manage_apt  = false
      $filebeat_path = '/usr/bin/filebeat'
      $major_version = '7'
    }
    'OpenBSD': {
      $manage_repo = false
      $manage_apt  = false
      $filebeat_path = '/usr/local/bin/filebeat'
      # lint:ignore:only_variable_string
      $major_version = versioncmp('6.3', $facts['kernelversion']) < 0 ? {
        # lint:endignore
        true    => '6',
        default => '5'
      }
    }
    default: {
      $manage_repo = true
      $manage_apt  = true
      $filebeat_path = '/usr/share/filebeat/bin/filebeat'
      $major_version = '9'
    }
  }
  case $facts['kernel'] {
    'Linux'   : {
      $package_ensure    = present
      $config_file       = '/etc/filebeat/filebeat.yml'
      $config_dir        = '/etc/filebeat/conf.d'
      $config_file_owner = 'root'
      $config_file_group = 'root'
      $config_dir_owner  = 'root'
      $config_dir_group  = 'root'
      $modules_dir        = '/etc/filebeat/modules.d'
      # These parameters are ignored if/until tarball installs are supported in Linux
      $tmp_dir         = '/tmp'
      $install_dir     = undef
      case $facts['os']['family'] {
        'RedHat': {
          $service_provider = 'systemd'
        }
        default: {
          $service_provider = undef
        }
      }
      $url_arch        = undef
    }

    'SunOS': {
      $package_ensure    = present
      $config_file       = '/opt/local/etc/beats/filebeat.yml'
      $config_dir        = '/opt/local/etc/filebeat.d'
      $config_file_owner = 'root'
      $config_file_group = 'root'
      $config_dir_owner  = 'root'
      $config_dir_group  = 'root'
      $modules_dir       = '/opt/local/etc/filebeat.modules.d'
      $tmp_dir           = '/tmp'
      $service_provider  = undef
      $install_dir       = undef
      $url_arch          = undef
    }

    'FreeBSD': {
      $package_ensure    = present
      $config_file       = '/usr/local/etc/beats/filebeat.yml'
      $config_dir        = '/usr/local/etc/beats/filebeat.d'
      $config_file_owner = 'root'
      $config_file_group = 'wheel'
      $config_dir_owner  = 'root'
      $config_dir_group  = 'wheel'
      $modules_dir       = '/usr/local/etc/beats/filebeat.modules.d'
      $tmp_dir           = '/tmp'
      $service_provider  = undef
      $install_dir       = undef
      $url_arch          = undef
    }

    'OpenBSD': {
      $package_ensure    = present
      $config_file       = '/etc/filebeat/filebeat.yml'
      $config_dir        = '/etc/filebeat/conf.d'
      $config_file_owner = 'root'
      $config_file_group = 'wheel'
      $config_dir_owner  = 'root'
      $config_dir_group  = 'wheel'
      $modules_dir        = '/etc/filebeat/modules.d'
      $tmp_dir           = '/tmp'
      $service_provider  = undef
      $install_dir       = undef
      $url_arch          = undef
    }

    'Windows' : {
      $package_ensure   = '7.1.0'
      $config_file_owner = 'Administrator'
      $config_file_group = undef
      $config_dir_owner = 'Administrator'
      $config_dir_group = undef
      $config_file      = 'C:/Program Files/Filebeat/filebeat.yml'
      $config_dir       = 'C:/Program Files/Filebeat/conf.d'
      $modules_dir      = 'C:/Program Files/Filebeat/modules.d'
      $install_dir      = 'C:/Program Files'
      $tmp_dir          = 'C:/Windows/Temp'
      $service_provider = undef
      $url_arch         = $facts['os']['architecture'] ? {
        'x86'   => 'x86',
        'x64'   => 'x86_64',
        default => fail("${facts['os']['architecture']} is not supported by filebeat."),
      }
    }

    default : {
      fail($kernel_fail_message)
    }
  }

  if 'filebeat_version' in $facts and $facts['filebeat_version'] != false {
    # filestream input type added in 7.10, deprecated in 7.16
    if versioncmp($facts['filebeat_version'], '7.10') > 0 {
      $default_input_type = 'filestream'
    } else {
      $default_input_type = 'log'
    }
  } else {
    $default_input_type = 'filestream'
  }
}
