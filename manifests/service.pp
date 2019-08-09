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

  $major_version = $filebeat::major_version

  if versioncmp($major_version, '7') >= 0 {

    $logging = $filebeat::logging

    ensure_resource('file',
      $filebeat::systemd_drop_in_dir,
      {
        ensure => 'directory',
      }
    )

    ensure_resource('file',
      "${filebeat::systemd_drop_in_dir}/logging.conf",
      {
        ensure  => 'present',
        content => template($filebeat::systemd_log_opt_template),
        require => File[$filebeat::systemd_drop_in_dir],
        notify  => Service['filebeat'],
      }
    )

  }
}
