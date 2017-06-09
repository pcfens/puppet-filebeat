class filebeat::install::windows {
  $filename = regsubst($filebeat::real_download_url, '^https?.*\/([^\/]+)\.[^.].*', '\1')
  $foldername = 'Filebeat'

  file { $filebeat::install_dir:
    ensure => directory,
  }

  remote_file { "${filebeat::tmp_dir}/${filename}.zip":
    ensure      => present,
    source      => $filebeat::real_download_url,
    verify_peer => false,
    proxy       => $filebeat::proxy_address,
  }

  exec { "unzip ${filename}":
    command  => "\$sh=New-Object -COM Shell.Application;\$sh.namespace((Convert-Path '${filebeat::install_dir}')).Copyhere(\$sh.namespace((Convert-Path '${filebeat::tmp_dir}/${filename}.zip')).items(), 16)",
    creates  => "${filebeat::install_dir}/Filebeat/${filename}",
    provider => powershell,
    require  => [
      File[$filebeat::install_dir],
      Remote_file["${filebeat::tmp_dir}/${filename}.zip"],
    ],
  }

  # You can't remove the old dir while the service has files locked...
  exec { "stop service ${filename}":
    command  => 'Set-Service -Name filebeat -Status Stopped',
    creates  => "${filebeat::install_dir}/Filebeat/${filename}",
    onlyif   => 'if(Get-WmiObject -Class Win32_Service -Filter "Name=\'filebeat\'") {exit 0} else {exit 1}',
    provider => powershell,
    require  => Exec["unzip ${filename}"],
  }

  exec { "rename ${filename}":
    command  => "Remove-Item '${filebeat::install_dir}/Filebeat' -Recurse -Force -ErrorAction SilentlyContinue; Rename-Item '${filebeat::install_dir}/${filename}' '${filebeat::install_dir}/Filebeat'",
    creates  => "${filebeat::install_dir}/Filebeat/${filename}",
    provider => powershell,
    require  => Exec["stop service ${filename}"],
  }

  exec { "mark ${filename}":
    command  => "New-Item '${filebeat::install_dir}/Filebeat/${filename}' -ItemType file",
    creates  => "${filebeat::install_dir}/Filebeat/${filename}",
    provider => powershell,
    require  => Exec["rename ${filename}"],
  }

  exec { "install ${filename}":
    cwd         => "${filebeat::install_dir}/Filebeat",
    command     => './install-service-filebeat.ps1',
    refreshonly => true,
    provider    => powershell,
    subscribe   => Exec["mark ${filename}"],
  }
}
