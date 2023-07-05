# filebeat::service
#
# Manage the filebeat service
#
# @summary Manage the filebeat service
class filebeat::service (
  Boolean $manage_systemd_service_directory  = true,
) {
  service { 'filebeat':
    ensure   => $filebeat::real_service_ensure,
    enable   => $filebeat::real_service_enable,
    provider => $filebeat::service_provider,
  }

  $major_version                  = $filebeat::major_version
  $systemd_beat_log_opts_override = $filebeat::systemd_beat_log_opts_override

  #make sure puppet client version 6.1+ with filebeat version 7+, running on systemd
  if ( versioncmp( $major_version, '7'   ) >= 0 and
  $filebeat::service_provider == 'systemd' ) {
    if ( versioncmp( $clientversion, '6.1' ) >= 0 ) {
      unless $systemd_beat_log_opts_override == undef {
        $ensure_overide = 'present'
      } else {
        $ensure_overide = 'absent'
      }

      if $manage_systemd_service_directory {
        ensure_resource('file',
          $filebeat::systemd_override_dir,
          {
            ensure => 'directory',
          }
        )
      }

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
        file { $filebeat::systemd_override_dir:
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
