class filebeat::repo {
  case $::osfamily {
    'Debian': {
      include ::apt
      Class['apt::update'] -> Package['filebeat']

      apt::source { 'filebeat':
        location => 'http://packages.elastic.co/beats/apt',
        release  => 'stable',
        repos    => 'main',
        key      => {
          id     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
          source => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
        },
      }

    }
    'RedHat', 'Linux': {
      yumrepo { 'filebeat':
        descr    => 'elasticsearch repo',
        baseurl  => 'https://packages.elastic.co/beats/yum/el/$basearch',
        gpgcheck => 1,
        gpgkey   => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
        enabled  => 1,
      }
    }
    'Suse': {
      exec { 'filebeat_suse_import_gpg':
        command => 'rpmkeys --import http://packages.elastic.co/GPG-KEY-elasticsearch',
        unless  => 'test $(rpm -qa gpg-pubkey | grep -i "D88E42B4" | wc -l) -eq 1 ',
        notify  => [ Zypprepo['elasticsearch'] ],
      }

      zypprepo { 'filebeat':
        baseurl     => 'https://packages.elastic.co/beats/yum/el/$basearch',
        enabled     => 1,
        autorefresh => 1,
        name        => 'elasticsearch',
        gpgcheck    => 1,
        gpgkey      => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
        type        => 'yum',
      }
    }
    default: {
      fail($fail_message)
    }
  }
}
