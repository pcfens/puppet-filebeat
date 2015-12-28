class filebeat::install (
    $download_url = $filebeat::download_url,
    $install_dir  = $filebeat::install_dir,
    $tmp_dir      = $filebeat::tmp_dir,

) {
    $filename = regsubst($download_url, '^https.*\/([^\/]+)\.[^.].*', '\1')
    $foldername = 'Filebeat'

    file { $tmp_dir:
      ensure => directory
    }
    file { $install_dir:
      ensure => directory
    }

    exec { "download ${filename}":
        command  => "(New-Object System.Net.WebClient).DownloadFile('${download_url}', '${tmp_dir}/${filename}.zip')",
        onlyif   => "if(Test-Path -Path '${tmp_dir}/${filename}.zip') { exit 1 } else { exit 0 }",
        provider => powershell,
        require  => File[$tmp_dir]
    }
    exec { "unzip ${filename}":
        command  => "\$sh=New-Object -COM Shell.Application;\$sh.namespace((Convert-Path '${install_dir}')).Copyhere(\$sh.namespace((Convert-Path '${tmp_dir}/${filename}.zip')).items(), 16)",
        creates  => "${install_dir}/Filebeat",
        provider => powershell,
        require  => [Exec["download ${filename}"],File[$install_dir]],
    }
    exec { 'rename folder':
        command  => "Rename-Item '${install_dir}/${filename}' Filebeat",
        creates  => "${install_dir}/Filebeat",
        provider => powershell,
        require  => Exec["unzip ${filename}"],
    }
    exec { "install ${filename}":
        cwd      => "${install_dir}/Filebeat",
        command  => './install-service-filebeat.ps1',
        onlyif   => "if(Get-WmiObject -Class Win32_Service -Filter \"Name='filebeat'\") { exit 1 } else {exit 0 }",
        provider =>  powershell,
        require  => Exec['rename folder'],
    }
}