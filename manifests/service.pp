# filebeat::service
#
# Manage the filebeat service
#
# @summary Manage the filebeat service
class filebeat::service {
  service { 'filebeat':
    ensure   => $filebeat::real_service_ensure,
    enable   => $filebeat::service_enable,
    provider => $filebeat::service_provider,
  }

  $major_version                  = $filebeat::major_version
  $systemd_beat_log_opts_override = $filebeat::systemd_beat_log_opts_override

  #make sure puppet client version 6.1+ with filebeat version 7+, running on systemd
  if ( versioncmp( $major_version, '7'   ) >= 0 and
      versioncmp( $::clientversion, '6.1' ) >= 0 and
      $::service_provider == 'systemd' ) {

    unless $systemd_beat_log_opts_override == undef {
      $ensure_overide = 'present'
    } else {
      $ensure_overide = 'absent'
    }

    ensure_resource('file',
      $filebeat::systemd_drop_in_dir,
      {
        ensure => 'directory',
      }
    )

    ensure_resource('file',
      "${filebeat::systemd_drop_in_dir}/logging.conf",
      {
        ensure  => $ensure_overide,
        content => template($filebeat::systemd_beat_log_opts_template),
        require => File[$filebeat::systemd_drop_in_dir],
        notify  => Service['filebeat'],
      }
    )

  }
}
