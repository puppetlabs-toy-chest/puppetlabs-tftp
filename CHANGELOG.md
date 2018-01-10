# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [1.0.0]
### Added
- Add puppet 4 and 5
- Add recent Ubuntu versions

### Fixed
- Upper bound for puppetlabs-xinetd dependency
- Fix systemd on Ubuntu 15.04 and later
- Licensing file contents to follow Apache-2.0
- Rubocop and modulesync configuration

## 2015-01-27 - Release 0.2.3
### Summary

This release includes lint and metadata fixes and fixes the package references to point to the virtual package.

## 2014-08-20 - Release 0.2.2
### Summary

Add package require for the tftp xinetd::service

## 2012-08-21 - Release 0.2.1
### Summary

Fix permission issues related to xinetd

## 2012-07-27 - Release 0.2.0

#### Features
- Add support for RHEL/CentOS
- Use xinetd rather than inetd
- Enable xinetd by default

## 2012-06-25 - Release 0.1.1

#### Features
- Add recurse support for tftp::file.
- Add source defaults for tftp::file.
- Add travis ci and puppet spec_helper support.

## 2012-05-01 - Release 0.1.0
### Summary

Initial release of module.

[1.0.0]: https://github.com/puppetlabs/puppetlabs-tftp/compare/0.2.3...1.0.0
