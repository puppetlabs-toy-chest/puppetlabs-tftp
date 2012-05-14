# Class: tftp
#
# Parameters:
#
#   [*username*]: tftp service username.
#   [*directory*]: tftp service file directory.
#   [*address*]: tftp service bind address (default 0.0.0.0).
#   [*port*]: tftp service bind port (default 69).
#   [*options*]: tftp service bind port (default 69).
#   [*inetd*]: tftp service bind port (default 69).
#   [*inetd_conf*]: tftp service bind port (default 69).
#
# Actions:
#
# Requires:
#
#   puppetlabs-inetd when inetd = true.
#
# Usage:
#
#   class tftp {
#     directory => '/opt/tftp',
#     address   => $::ipaddress,
#     options   => '--ipv6 --timeout 60',
#   }
#
class tftp (
  $username   = $tftp::params::username,
  $directory  = $tftp::params::directory,
  $address    = $tftp::params::address,
  $port       = $tftp::params::port,
  $options    = $tftp::params::options,
  $inetd      = false,
  $inetd_conf = $tftp::params::inetd_conf
) inherits tftp::params {
  package { 'tftpd-hpa':
    ensure => present,
  }

  file { '/etc/default/tftpd-hpa':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('tftp/tftpd-hpa.erb'),
    require => Package['tftpd-hpa'],
  }

  if $inetd {
    if $options != '--secure' {
      fail('tftp class does not support custom options when inetd is enabled.')
    }

    include 'inetd'

    augeas { 'inetd_tftp':
      changes => [
        "ins tftp after /files${inetd_conf}",
        "set /files${inetd_conf}/tftp/socket dgram",
        "set /files${inetd_conf}/tftp/protocol udp",
        "set /files${inetd_conf}/tftp/wait wait",
        "set /files${inetd_conf}/tftp/user ${username}",
        "set /files${inetd_conf}/tftp/command /usr/libexec/tftpd",
        "set /files${inetd_conf}/tftp/arguments/1 tftpd",
        "set /files${inetd_conf}/tftp/arguments/2 --address",
        "set /files${inetd_conf}/tftp/arguments/3 ${address}:${port}",
        "set /files${inetd_conf}/tftp/arguments/4 --secure",
        "set /files${inetd_conf}/tftp/arguments/5 ${directory}",
      ],
      require => Class['inetd'],
    }

    $svc_ensure = stopped
    $svc_enable = false
  } else {
    $svc_ensure = running
    $svc_enable = true
  }

  service { 'tftpd-hpa':
    ensure    => $svc_ensure,
    enable    => $svc_enable,
    provider  => $tftp::params::provider,
    hasstatus => $tftp::params::hasstatus,
    pattern   => '/usr/sbin/in.tftpd',
    subscribe => File['/etc/default/tftpd-hpa'],
  }
}
