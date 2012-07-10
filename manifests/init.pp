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
#   class { 'tftp':
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
  $inetd_conf = $tftp::params::inetd_conf,
  $package    = $tftp::params::package,
  $binary     = $tftp::params::binary,
  $defaults   = $tftp::params::defaults
) inherits tftp::params {

  package { 'tftpd-hpa':
    ensure  => present,
    name    => $package,
  }
  if $defaults {
	  file { '/etc/default/tftpd-hpa':
	    ensure  => file,
	    owner   => 'root',
	    group   => 'root',
	    mode    => '0644',
	    content => template('tftp/tftpd-hpa.erb'),
	    require => Package['tftpd-hpa'],
      notify  => Service['tftpd-hpa'],
	  }
  }

  if $inetd {
    if $options != '--secure' {
      fail('tftp class does not support custom options when inetd is enabled.')
    }

    include 'xinetd'

    xinetd::service { 'tftp':
      port        => $port,
      protocol    => 'udp',
      server_args => "${options} ${directory}",
      server      => $binary,
      user        => $username,
      bind        => $address,
      socket_type => 'dgram',
      cps         => '100 2',
      flags       => 'IPv4',
      per_source  => '11',
      wait        => 'yes',
  }
    $svc_ensure = stopped
    $svc_enable = false
  } else {
    $svc_ensure = running
    $svc_enable = true
  }

  $start = $provider ? {
    'base'  => "${binary} -l -a ${address}:${port} -u ${username} ${options} ${directory}",
    default => undef
  }

  service { 'tftpd-hpa':
    ensure    => $svc_ensure,
    enable    => $svc_enable,
    provider  => $tftp::params::provider,
    hasstatus => $tftp::params::hasstatus,
    pattern   => '/usr/sbin/in.tftpd',
    start     => $start,
  }
}
