class filebeat::config {

  $filebeat_config = {
    'filebeat' => {
      'spool_size'    => $filebeat::spool_size,
      'idle_timeout'  => $filebeat::idle_timeout,
      'registry_file' => $filebeat::registry_file,
      'config_dir'    => $filebeat::config_dir,
    },
    'output'   => $filebeat::outputs,
    'shipper'  => $filebeat::shipper,
    'logging'  => $filebeat::logging,
  }

  $template_file = versioncmp($::puppetversion, '4.0.0') ? {
    '-1'    => 'filebeat3.yml.erb',
    default => 'filebeat.yml.erb',
  }

  case $::kernel {
    'Linux'   : {
      file {'filebeat.yml':
        ensure  => file,
        path    => '/etc/filebeat/filebeat.yml',
        content => template("${module_name}/${template_file}"),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service['filebeat'],
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Linux

    'Windows' : {
      file {'filebeat.yml':
        ensure  => file,
        path    => 'C:/Program Files/Filebeat/filebeat.yml',
        content => template("${module_name}/${template_file}"),
        notify  => Service['filebeat'],
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Windows
    default : {
      fail($filebeat::fail_message)
    }
  }
}
