class filebeat::config {
  file {'filebeat.yml':
    ensure  => file,
    path    => '/etc/filebeat/filebeat.yml',
    content => template("${module_name}/filebeat.yml.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['filebeat'],
  }

  file {'filebeat-config-dir':
    ensure => directory,
    path   => $filebeat::config_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
