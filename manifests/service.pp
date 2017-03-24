class filebeat::service {
  service { 'filebeat':
    ensure   => $filebeat::real_service_ensure,
    enable   => $filebeat::service_enable,
    provider => $filebeat::service_provider,
  }
}
