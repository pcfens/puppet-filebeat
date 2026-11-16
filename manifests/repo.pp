# filebeat::repo
#
# Manage the repository for Filebeat (Linux only for now)
#
# @summary Manages the yum, apt, and zypp repositories for Filebeat
class filebeat::repo {
  $debian_repo_url = "https://artifacts.elastic.co/packages/${filebeat::major_version}.x/apt"
  $yum_repo_url = "https://artifacts.elastic.co/packages/${filebeat::major_version}.x/yum"

  case $facts['os']['family'] {
    'Debian': {
      if $filebeat::manage_apt == true {
        include apt
      }

      Class['apt::update'] -> Package['filebeat']

      # For version 9.x, use explicit GPG key import to /etc/apt/keyrings
      # Older versions use the apt::source key management
      if $filebeat::major_version == '9' {
        # Ensure the keyrings directory exists
        if !defined(File['/etc/apt/keyrings']) {
          file { '/etc/apt/keyrings':
            ensure => directory,
            mode   => '0755',
          }
        }

        # Import Elastic GPG key
        if !defined(Exec['import-elastic-gpg-key']) {
          exec { 'import-elastic-gpg-key':
            command => 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor > /etc/apt/keyrings/elastic-archive-keyring.gpg',
            unless  => 'test -f /etc/apt/keyrings/elastic-archive-keyring.gpg && gpg --dry-run --quiet --import --import-options import-show /etc/apt/keyrings/elastic-archive-keyring.gpg 2>&1 | grep -q D88E42B4',
            path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
            require => File['/etc/apt/keyrings'],
            notify  => Exec['apt_update'],
          }
        }

        if !defined(Apt::Source['beats']) {
          apt::source { 'beats':
            ensure   => $filebeat::alternate_ensure,
            location => $debian_repo_url,
            release  => 'stable',
            repos    => 'main',
            pin      => $filebeat::repo_priority,
            keyring  => '/etc/apt/keyrings/elastic-archive-keyring.gpg',
            require  => Exec['import-elastic-gpg-key'],
            notify   => Exec['apt_update'],
          }
        }
      } else {
        # For versions < 9, use standard apt::source key management
        if !defined(Apt::Source['beats']) {
          apt::source { 'beats':
            ensure   => $filebeat::alternate_ensure,
            location => $debian_repo_url,
            release  => 'stable',
            repos    => 'main',
            pin      => $filebeat::repo_priority,
            key      => {
              name   => 'elastic-archive-keyring.gpg',
              source => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
            },
          }
        }
      }
    }
    'RedHat', 'Linux': {
      if !defined(Yumrepo['beats']) {
        yumrepo { 'beats':
          ensure   => $filebeat::alternate_ensure,
          descr    => 'elastic beats repo',
          baseurl  => $yum_repo_url,
          gpgcheck => 1,
          gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          priority => $filebeat::repo_priority,
          enabled  => 1,
          notify   => Exec['flush-yum-cache'],
        }
      }

      exec { 'flush-yum-cache':
        command     => 'yum clean all',
        refreshonly => true,
        path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      }
    }
    'Suse': {
      exec { 'topbeat_suse_import_gpg':
        command => 'rpmkeys --import https://artifacts.elastic.co/GPG-KEY-elasticsearch',
        unless  => 'test $(rpm -qa gpg-pubkey | grep -i "D88E42B4" | wc -l) -eq 1 ',
        notify  => [Zypprepo['beats']],
      }
      if !defined(Zypprepo['beats']) {
        zypprepo { 'beats':
          ensure      => $filebeat::alternate_ensure,
          baseurl     => $yum_repo_url,
          enabled     => 1,
          autorefresh => 1,
          name        => 'beats',
          gpgcheck    => 1,
          gpgkey      => 'https://packages.elastic.co/GPG-KEY-elasticsearch',
          type        => 'yum',
        }
      }
    }
    default: {
      fail($filebeat::osfamily_fail_message)
    }
  }
}
