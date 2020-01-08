# to manage filebeat installation on OpenBSD
class filebeat::install::openbsd {
  package { $filebeat::package_name:
    ensure => $filebeat::package_ensure,
  }
}
