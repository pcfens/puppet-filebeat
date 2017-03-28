class filebeat::install::freebsd {
  package {'filebeat':
    ensure => $filebeat::package_ensure,
  }
  file { $filebeat::directory:
    ensure => 'directory',
    mode   => '0660',
  }
}
