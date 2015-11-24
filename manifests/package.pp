class filebeat::package {
  package {'filebeat':
    ensure => $filebeat::package_ensure,
  }
}
