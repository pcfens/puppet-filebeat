class { '::filebeat':
  package_ensure => '6.3.1',
  major_version  => '6',
  oss            => true,
  outputs        => {
    'logstash' => {
      'hosts' => [ 'localhost:5044', ],
    },
  },
}