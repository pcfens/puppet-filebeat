define filebeat::processor(
  $ensure         = present,
  $priority       = 10,
  $processor_name = $name,
  $params         = undef,
  $when           = undef,
) {
  include ::filebeat

  validate_integer($priority)
  validate_string($processor_name)

  if versioncmp($filebeat::real_version, '5') < 0 {
    fail('Processors only work on Filebeat 5.0 and higher')
  }

  if $priority < 10 {
    $_priority = "0${priority}"
  }
  else {
    $_priority = $priority
  }

  if $processor_name == 'drop_field' and $when == undef {
    fail('drop_event processors require a condition, without one ALL events are dropped')
  }
  elsif $processor_name != 'add_cloud_metadata' and $params == undef {
    fail("${processor_name} requires parameters to function as expected")
  }

  if $processor_name == 'add_cloud_metadata' {
    $_configuration = delete_undef_values(merge({'timeout' => '3s'}, $params))
  }
  elsif $processor_name == 'drop_field' {
    $_configuration = $when
  }
  else {
    $_configuration = delete_undef_values(merge({'when' => $when}, $params))
  }

  $processor_config = delete_undef_values({
    'processors' => [
      {
        "${processor_name}" => $_configuration
      },
    ],
  })

  case $::kernel {
    'Linux': {
      file{"filebeat-processor-${name}":
        ensure  => $ensure,
        path    => "${filebeat::config_dir}/${_priority}-processor-${name}.yml",
        owner   => 'root',
        group   => 'root',
        mode    => $::filebeat::config_file_mode,
        content => inline_template('<%= @processor_config.to_yaml() %>'),
        notify  => Class['filebeat::service'],
      }
    }
    'Windows': {
      file{"filebeat-processor-${name}":
        ensure  => $ensure,
        path    => "${filebeat::config_dir}/${_priority}-processor-${name}.yml",
        content => inline_template('<%= @processor_config.to_yaml() %>'),
        notify  => Class['filebeat::service'],
      }
    }
    default: {
      fail($filebeat::kernel_fail_message)
    }
  }
}
