# filebeat::module
#
# @summary Base resource to manage Filebeat modules. Check filebeat::module::* for specific implementations.
#
# @example
#   filebeat::module { 'namevar': 
#     config => {
#       'log' => {
#         'enabled' => true,
#         'var.paths' => [ '/var/log/*.log' ],
#       },
#     },
#   }
#
# @param ensure Present or absent. Default: present.
# @param config Hash with the module configuration.
#
define filebeat::module (
  Enum['absent', 'present'] $ensure = present,
  Hash $config = {},
) {
  $filebeat_config = [{ 'module' => $name } + $config]

  case $facts['kernel'] {
    'Linux', 'OpenBSD' : {
      file { "filebeat-module-${name}":
        ensure  => $ensure,
        path    => "${filebeat::modules_dir}/${name}.yml",
        owner   => 'root',
        group   => '0',
        mode    => $filebeat::config_file_mode,
        content => template("${module_name}/pure_hash.yml.erb"),
        notify  => Service['filebeat'],
        before  => File['filebeat.yml'],
      }
    }

    'FreeBSD' : {
      file { "filebeat-module-${name}":
        ensure  => $ensure,
        path    => "${filebeat::modules_dir}/${name}.yml",
        owner   => 'root',
        group   => 'wheel',
        mode    => $filebeat::config_file_mode,
        content => template("${module_name}/pure_hash.yml.erb"),
        notify  => Service['filebeat'],
        before  => File['filebeat.yml'],
      }
    }

    'Windows' : {
      file { "filebeat-module-${name}":
        ensure  => $ensure,
        path    => "${filebeat::modules_dir}/${name}.yml",
        content => template("${module_name}/pure_hash.yml.erb"),
        notify  => Service['filebeat'],
        before  => File['filebeat.yml'],
      }
    }

    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
