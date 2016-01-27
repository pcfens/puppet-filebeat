# puppet-filebeat

[![Build Status](https://travis-ci.org/pcfens/puppet-filebeat.svg?branch=master)](https://travis-ci.org/pcfens/puppet-filebeat)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with filebeat](#setup)
    - [What filebeat affects](#what-filebeat-affects)
    - [Setup requirements](#setup-requirements)
    - [Beginning with filebeat](#beginning-with-filebeat)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference](#reference)
    - [Public Classes](#public-classes)
    - [Private Classes](#private-classes)
    - [Public Defines](#public-defines)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

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

To ship files to [elasticsearch](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration-details.html#elasticsearch-output):
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

To ship log files through [logstash](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration-details.html#logstash-output):
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

[Shipper](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration-details.html#configuration-shipper) and [logging](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration-details.html#configuration-logging) options can be configured the same way, and are documented on the [elastic website](https://www.elastic.co/guide/en/beats/filebeat/current/index.html).

### Adding a prospector

Prospectors are processes that ship log files to elasticsearch or logstash. They can
be defined as a hash added to the class declaration (also used for automatically creating
prospectors using hiera), or as their own defined resources.

At a minimum, the `paths` parameter must be set to an array of files or blobs that should
be shipped. `log_type` is what logstash views as the type parameter if you'd like to
apply conditional filters.

```puppet
filebeat::prospector { 'syslogs':
  paths    => [
    '/var/log/auth.log',
    '/var/log/syslog',
  ],
  log_type => 'syslog-beat',
}
```

#### Multiline Logs

Filebeat prospectors (versions >= 1.1) can handle multiline log entries. The `multiline`
parameter accepts a hash containing `pattern`, `negate`, `match`, `max_lines`, and `timeout`
as documented in the filebeat [configuration documentation](https://www.elastic.co/guide/en/beats/filebeat/1.1/filebeat-configuration-details.html#multiline).

## Reference
 - [**Public Classes**](#public-classes)
    - [Class: filebeat](#class-filebeat)
 - [**Private Classes**](#private-classes)
    - [Class: filebeat::config](#class-filebeatconfig)
    - [Class: filebeat::install](#class-filebeatinstall)
    - [Class: filebeat::params](#class-filebeatparams)
    - [Class: filebeat::repo](#class-filebeatrepo)
    - [Class: filebeat::service](#class-filebeatservice)
    - [Class: filebeat::install::linux](#class-filebeatinstalllinux)
    - [Class: filebeat::install::windows](#class-filebeatinstallwindows)
 - [**Public Defines**](#public-defines)
    - [Define: filebeat::prospector](#define-filebeatprospector)

### Public Classes

#### Class: `filebeat`

Installs and configures filebeat.

**Parameters within `filebeat`**
- `package_ensure`: [String] The ensure parameter for the filebeat package (default: present)
- `manage_repo`: [Boolean] Whether or not the upstream (elastic) repo should be configured or not (default: true)
- `service_ensure`: [String] The ensure parameter on the filebeat service (default: running)
- `service_enable`: [String] The enable parameter on the filebeat service (default: true)
- `spool_size`: [Integer] How large the spool should grow before being flushed to the network (default: 1024)
- `idle_timeout`: [String] How often the spooler should be flushed even if spool size isn't reached (default: 5s)
- `registry_file`: [String] The registry file used to store positions, absolute or relative to working directory (default .filebeat)
- `config_dir`: [String] The directory where prospectors should be defined (default: /etc/filebeat/conf.d)
- `config_dir_mode`: [String] The permissions mode set on the configuration directory (default: 0755)
- `config_file_mode`: [String] The permissions mode set on configuration files (default: 0644)
- `purge_conf_dir`: [Boolean] Should files in the prospector configuration directory not managed by puppet be automatically purged
- `outputs`: [Hash] Will be converted to YAML for the required outputs section of the configuration (see documentation, and above)
- `shipper`: [Hash] Will be converted to YAML to create the optional shipper section of the filebeat config (see documentation)
- `logging`: [Hash] Will be converted to YAML to create the optional logging section of the filebeat config (see documentation)
- `conf_template`: [String] The configuration template to use to generate the main filebeat.yml config file
- `download_url`: [String] The URL of the zip file that should be downloaded to install filebeat (windows only)
- `install_dir`: [String] Where filebeat should be installed (windows only)
- `tmp_dir`: [String] Where filebeat should be temporarily downloaded to so it can be installed (windows only)
- `prospectors`: [Hash] Prospectors that will be created. Commonly used to create prospectors using hiera

### Private Classes

#### Class: `filebeat::config`

Creates the configuration files required for filebeat (but not the prospectors)

#### Class: `filebeat::install`

Calls the correct installer class based on the kernel fact.

#### Class: `filebeat::params`

Sets default parameters for `filebeat` based on the OS and other facts.

#### Class: `filebeat::repo`

Installs the yum or apt repository for the system package manager to install filebeat.

#### Class: `filebeat::service`

Configures and manages the filebeat service.

#### Class: `filebeat::install::linux`

Install the filebeat package on Linux kernels.

#### Class: `filebeat::install::windows`

Downloads, extracts, and installs the filebeat zip file in Windows.

### Public Defines

#### Define: `filebeat::prospector`

Installs a configuration file for a prospector.

Be sure to read the [filebeat configuration details](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration-details.html)
to fully understand what these parameters do.

**Parameters for `filebeat::prospector`**
  - `ensure`: The ensure parameter on the prospector configuration file. (default: present)
  - `paths`: [Array] The paths, or blobs that should be handled by the prospector. (required)
  - `exclude_files`: [Array] Files that match any regex in the list are excluded from filebeat (default: [])
  - `encoding`: [String] The file encoding. (default: plain)
  - `input_type`: [String] log or stdin - where filebeat reads the log from (default:log)
  - `fields`: [Hash] Optional fields to add information to the output (default: {})
  - `fields_under_root`: [Boolean] Should the `fields` parameter fields be stored at the top level of indexed documents.
  - `ignore_older`: [String] Files older than this field will be ignored by filebeat (default: 24h)
  - `log_type`: [String] (Deprecated - use `doc_type`) The document_type setting (optional - default: log)
  - `doc_type`: [String] The event type to used for published lines, used as type field in logstash
    and elasticsearch (optional - default: log)
  - `scan_frequency`: [String] How often should the prospector check for new files (default: 10s)
  - `harvester_buffer_size`: [Integer] The buffer size the harvester uses when fetching the file (default: 16384)
  - `tail_files`: [Boolean] If true, filebeat starts reading new files at the end instead of the beginning (default: false)
  - `backoff`: [String] How long filebeat should wait between scanning a file after reaching EOF (default: 1s)
  - `max_backoff`: [String] The maximum wait time to scan a file for new lines to ship (default: 10s)
  - `backoff_factor`: [Integer] `backoff` is multiplied by this parameter until `max_backoff` is reached to
    determine the actual backoff (default: 2)
  - `partial_line_waiting`: [String] How long should the prospector wait before shipping a file with
    a potentially incomplete last line (default: 5s)
  - `force_close_files`: [Boolean] Should filebeat forcibly close a file when renamed (default: false)
  - `include_lines`: [Array] A list of regular expressions to match the lines that you want to include.
    Ignored if empty (default: [])
  - `exclude_lines`: [Array] A list of regular expressions to match the files that you want to exclude.
    Ignored if empty (default: [])
  - `max_bytes`: [Integer] The maximum number of bytes that a single log message can have (default: 10485760)
  - `multiline`: [Hash] Options that control how Filebeat handles log messages that span multiple lines.
    [See above](#multiline-logs). (default: {})


## Limitations

This module doesn't load the [elasticsearch index template](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html#filebeat-template) into elasticsearch (required when shipping
directly to elasticsearch).

Only filebeat versions after 1.0.0-rc1 are supported. 1.0.0-rc1 and older don't
support YAML like the ruby template can easily generate.

## Development

Pull requests and bug reports are welcome. If you're sending a pull request, please consider
writing tests if applicable.
