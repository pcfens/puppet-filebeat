# to manage filebeat installation on SunOS
class filebeat::install::sunos {
  package {'beats':
    ensure => $filebeat::package_ensure,
  }
}
