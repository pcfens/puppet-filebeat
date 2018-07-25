class { 'filebeat':
  outputs => {
    'elasticsearch' => {
      'hosts'       => [
        'http://localhost:9200',
        'http://anotherserver:9200'
      ],
      'loadbalance' => true,
      'index'       => 'packetbeat',
      'cas'         => [
        '/etc/pki/root/ca.pem',
      ],
    },
  },
}