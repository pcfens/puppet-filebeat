Changelog
=========

## Unreleased
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.4.0...HEAD)

## [v0.4.0](https://github.com/pcfens/puppet-filebeat/tree/v0.4.0)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.3.1...v0.4.0)

This is the first release that includes changelog. Since v0.3.1:

**Fixed Bugs**
- 'fields' parse error in prospector.yml template [\#7](https://github.com/pcfens/puppet-filebeat/pull/7)

**New Features**
- Windows support [\#3](https://github.com/pcfens/puppet-filebeat/pull/3)
  - Requires the [`puppetlabs/powershell`](https://forge.puppetlabs.com/puppetlabs/powershell)
  and [`lwf/remote_file`](https://forge.puppetlabs.com/lwf/remote_file) modules.
- Config file and folder permissions can be managed [\#8](https://github.com/pcfens/puppet-filebeat/pull/8)
