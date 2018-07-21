# to manage filebeat installation on OpenBSD
class filebeat::install::openbsd {
  if $filebeat::oss {
    warning('No OSS version of filebeat available under OpenBSD')
  }

  package {'filebeat':
    ensure => $filebeat::package_ensure,
    name   => $filebeat::real_package_name,
  }
}
