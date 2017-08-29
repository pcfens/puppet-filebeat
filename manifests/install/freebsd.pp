class filebeat::install::freebsd {
  ensure_packages (['beats'], {ensure => $filebeat::package_ensure})
}
