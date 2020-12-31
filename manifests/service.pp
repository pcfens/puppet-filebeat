# filebeat::service
#
# Manage the filebeat service
#
# @summary Manage the filebeat service
class filebeat::service {
  if keys($filebeat::outputs).length <= 1 {
    service { 'filebeat':
      ensure   => $filebeat::real_service_ensure,
      enable   => $filebeat::real_service_enable,
      provider => $filebeat::service_provider,
    }
  }
  else {
    systemd::unit_file { "filebeat.service":
      content => template($filebeat::systemd_composite_service_template),
    }
    ~> service {'filebeat':
      enable => $filebeat::real_service_enable,
      ensure => $filebeat::real_service_ensure,
      provider => $filebeat::service_provider,
    }
  }

  $major_version                  = $filebeat::major_version
  $systemd_beat_log_opts_override = $filebeat::systemd_beat_log_opts_override

  #make sure puppet client version 6.1+ with filebeat version 7+, running on systemd
  if ( versioncmp( $major_version, '7'   ) >= 0 and
    $::service_provider == 'systemd' ) {

    if ( versioncmp( $::clientversion, '6.1' ) >= 0 ) {

      unless $systemd_beat_log_opts_override == undef {
        $ensure_overide = 'present'
      } else {
        $ensure_overide = 'absent'
      }

      ensure_resource('file',
        $filebeat::systemd_override_dir,
        {
          ensure => 'directory',
        }
      )

      file { "${filebeat::systemd_override_dir}/logging.conf":
        ensure  => $ensure_overide,
        content => template($filebeat::systemd_beat_log_opts_template),
        require => File[$filebeat::systemd_override_dir],
        notify  => Service['filebeat'],
      }

    } else {

      unless $systemd_beat_log_opts_override == undef {
        $ensure_overide = 'present'
      } else {
        $ensure_overide = 'absent'
      }

      if !defined(File[$filebeat::systemd_override_dir]) {
        file{$filebeat::systemd_override_dir:
          ensure => 'directory',
        }
      }

      file { "${filebeat::systemd_override_dir}/logging.conf":
        ensure  => $ensure_overide,
        content => template($filebeat::systemd_beat_log_opts_template),
        require => File[$filebeat::systemd_override_dir],
        notify  => Service['filebeat'],
      }

      unless defined('systemd') {
        warning('You\'ve specified an $systemd_beat_log_opts_override varible on a system running puppet version < 6.1 and not declared "systemd" resource See README.md for more information') # lint:ignore:140chars
      }
    }
  }
}
define filebeat::service::add {
  if  $::service_provider == 'systemd' {
    if $name == $filebeat::module_name {
      $service_name = $name
    }
    else {
      $service_name = "${filebeat::module_name}.${name}"
      file { "/var/lib/filebeat/${name}":
        ensure => directory,
        mode => '0750',
        owner => $filebeat::config_file_owner,
        group => $filebeat::config_file_group,
        before => Systemd::Unit_file["${filebeat::module_name}.${name}.service"],
      }
      file { "/var/log/filebeat/${name}":
        ensure => directory,
        mode => '0700',
        owner => $filebeat::config_file_owner,
        group => $filebeat::config_file_group,
        before => Systemd::Unit_file["${filebeat::module_name}.${name}.service"],
      }
    }
    systemd::unit_file { "${service_name}.service":
      content => template($filebeat::systemd_service_template),
    }
    ~> service {"${service_name}":
      enable => $filebeat::real_service_enable,
      ensure => $filebeat::real_service_ensure,
      provider => $filebeat::service_provider,
    }

  }
  else {
    warning("You\'re trying to add service to systemd for the additional output '${name}', but the system is using '${::service_provider}' instead of systemd.")
  }
}
