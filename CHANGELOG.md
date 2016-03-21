Changelog
=========

## Unreleased
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.8...HEAD)

## [v0.5.8](https://github.com/pcfens/puppet-filebeat/tree/v0.5.8)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.7...v0.5.8)

**Fixed Bugs**
- `doc_type` is now used in the documentation instead of the deprecated `log_type`
  [\#17](https://github.com/pcfens/puppet-filebeat/pull/17)
- RedHat based systems should be using the redhat service provider.
  [\#18](https://github.com/pcfens/puppet-filebeat/pull/18)


## [v0.5.7](https://github.com/pcfens/puppet-filebeat/tree/v0.5.7)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.6...v0.5.7)

**Fixed Bugs**
- Some configuration parameters should be rendered as integers, not strings
  [\#15](https://github.com/pcfens/puppet-filebeat/pull/15)


## [v0.5.6](https://github.com/pcfens/puppet-filebeat/tree/v0.5.6)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.5...v0.5.6)

**Fixed Bugs**
- Configuration files should use the `conf_template` parameter [\#14](https://github.com/pcfens/puppet-filebeat/pull/14)

## [v0.5.5](https://github.com/pcfens/puppet-filebeat/tree/v0.5.5)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.4...v0.5.5)

**Fixed Bugs**
- `rotate_every_kb` and `number_of_files` parameters in file outputs should be
  explicitly integers to keep filebeat happy. [\#13](https://github.com/pcfens/puppet-filebeat/issues/13)

## [v0.5.4](https://github.com/pcfens/puppet-filebeat/tree/v0.5.4)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.2...v0.5.4)

**Fixed Bugs**
- Fix template regression in v0.5.3

## [v0.5.2](https://github.com/pcfens/puppet-filebeat/tree/v0.5.2)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.1...v0.5.2)

- Use the anchor pattern instead of contain so that older versions of puppet
  are supported [\#12](https://github.com/pcfens/puppet-filebeat/pull/12)

## [v0.5.1](https://github.com/pcfens/puppet-filebeat/tree/v0.5.1)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.5.0...v0.5.1)

- Update metadata to reflect which versions of puppet are supported.

## [v0.5.0](https://github.com/pcfens/puppet-filebeat/tree/v0.5.0)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.4.1...v0.5.0)

- For prospectors, deprecate `log_type` in favor of `doc_type` to better
  match the actual configuration parameter. `document_type` is not used because
  it causes errors when running with a puppet master. `log_type` will be fully
  removed before module version 1.0.
  [\#9](https://github.com/pcfens/puppet-filebeat/issues/9)

**New Features**
- Add support for `exclude_files`, `exclude_lines`, `include_lines`, and `multiline`.
  Use of the new parameters requires a filebeat version >= 1.1
  ([\#10](https://github.com/pcfens/puppet-filebeat/issues/10), [\#11](https://github.com/pcfens/puppet-filebeat/issues/11))

## [v0.4.1](https://github.com/pcfens/puppet-filebeat/tree/v0.4.1)
[Full Changelog](https://github.com/pcfens/puppet-filebeat/compare/v0.4.0...v0.4.1)

**Fixed Bugs**
- Fix links in documentation to match the updated documentation

**New Features**
- Change repository resource names to beats (e.g. apt::source['beats'], etc.),
  and only declare them if they haven't already been declared. This way we only
  have one module for all beats modules managed through puppet.

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
