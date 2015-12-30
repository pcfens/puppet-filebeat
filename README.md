# puppet-filebeat

[![Build Status](https://travis-ci.org/pcfens/puppet-filebeat.svg?branch=master)](https://travis-ci.org/pcfens/puppet-filebeat)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with filebeat](#setup)
    * [What filebeat affects](#what-filebeat-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with filebeat](#beginning-with-filebeat)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

The `filebeat` module installs and configures the [filebeat log shipper](https://www.elastic.co/products/beats/filebeat) maintained by elastic.

## Setup

### What filebeat affects

By default `filebeat` adds a software repository to your system, and installs filebeat along
with required configurations.

### Setup Requirements

The `filebeat` module depends on [`puppetlabs/stdlib`](https://forge.puppetlabs.com/puppetlabs/stdlib), and on
[`puppetlabs/apt`](https://forge.puppetlabs.com/puppetlabs/apt) on Debian based systems.

### Beginning with filebeat

`filebeat` can be installed with `puppet module install pcfens-filebeat` (or with r10k, librarian-puppet, etc.)

The only required parameter, other than which files to ship, is the `outputs` parameter.

## Usage

All of the default values in filebeat follow the upstream defaults (at the time of writing).

To ship files to [elasticsearch](https://www.elastic.co/guide/en/beats/libbeat/1.0.0/configuration.html#_elasticsearch_output):
```puppet
class { 'filebeat':
  outputs => {
    'elasticsearch' => {
     'hosts' => [
       'http://localhost:9200',
       'http://anotherserver:9200'
     ],
     'index'       => 'packetbeat',
     'cas'         => [
        '/etc/pki/root/ca.pem',
     ],
    },
  },
}

```

To ship log files through [logstash](https://www.elastic.co/guide/en/beats/libbeat/1.0.0/configuration.html#logstash-output):
```puppet
class { 'filebeat':
  outputs => {
    'logstash'     => {
     'hosts' => [
       'localhost:5044',
       'anotherserver:5044'
     ],
     'loadbalance' => true,
    },
  },
}

```

[Shipper](https://www.elastic.co/guide/en/beats/libbeat/1.0.0/configuration.html#configuration-shipper) and [logging](https://www.elastic.co/guide/en/beats/libbeat/1.0.0/configuration.html#configuration-logging) options can be configured the same way, and are documented on the [elastic website](https://www.elastic.co/guide/en/beats/libbeat/1.0.0/configuration.html).

## Limitations

This module doesn't load the [elasticsearch index template](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html#filebeat-template) into elasticsearch (required when shipping
directly to elasticsearch).

Only filebeat versions after 1.0.0-rc1 are supported. 1.0.0-rc1 and older don't
support YAML like the ruby template can easily generate.

## Development

Pull requests and bug reports are welcome. If you're sending a pull request, please consider
writing tests if applicable.
