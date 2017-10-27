# puppet tftp module

## Overview

Install tftp-hpa package and configuration files

This module will install TFTP as a xinetd service by default. It can be overridden to run as a standalone daemon by setting the inetd parameter to false.

## Usage

### class tftp

Parameters:

* username: tftp daemon user, default tftp(debian) or nobody(redhat).
* directory: service directory, deafult see params class.
* address: bind address, default 0.0.0.0.
* port: bind port, default 69.
* options: service option, default --secure.
* inetd: run service via xinetd, default true.

Example:

```puppet
class tftp {
  directory => '/opt/tftp',
  address   => $::ipaddress,
  options   => '--ipv6 --timeout 60',
}
```

### tftp::file

Parameters:

* ensure: file type, default file.
* owner: file owner, default tftp.
* group: file group. default tftp.
* mode: file mode, default 0644 (puppet will change to 0755 for directories).
* content: file content.
* source: file source, defaults to puppet:///module/${caller_module_name}/${name} for files without content.
* recurse: directory recurse, default false.
* purge: directory recurse and purge.
* replace: replace directory with file or symlink, default undef.
* recurselimit: directory recurse limit, default undef.

Example:

```puppet
tftp::file { 'pxelinux.0':
  source => 'puppet:///modules/acme/pxelinux.0',
}

tftp::file { 'pxelinux.cfg':
  ensure => directory,
}

tftp::file { 'pxelinux.cfg/default':
  ensure => file,
  source => 'puppet:///modules/acme/pxelinux.cfg/default',
}
```

The last example can be abbreviated to the following if it's in the acme module:

```puppet
tftp::file { 'pxelinux.cfg/default': }
```

## Example

1. tftp directories not in the OS package defaults should be managed as file resources.
2. customization for the class tftp must be declared before using tftp::file resources.

Example:

```puppet
file { '/opt/tftp':
  ensure => directory,
}

class { 'tftp':
  directory => '/opt/tftp',
  address   => $::ipaddress,
}

tftp::file { 'pxelinux.0':
  source => 'puppet:///modules/acme/pxelinux.0',
}
```

The examples use a module acme and the tftp files should be placed relative to the `files` directory of the calling module, i.e. ($modulepath/acme/files/).

## Supported Platforms

The module has been tested on the following platforms. Testing and patches for other platforms are welcomed.

* Debian 7 (Wheezy)
* EL 5
* EL 6
* Ubuntu 12.04
* Ubuntu 14.04
* Ubuntu 16.04
