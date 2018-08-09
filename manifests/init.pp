# Class: tftp
#
# Parameters:
#
#   [*username*]: tftp service username.
#   [*directory*]: tftp service file directory.
#   [*address*]: tftp service bind address (default 0.0.0.0).
#   [*address_ipv6*]: tftp service bind address for IPv6 (default ::).
#   [*port*]: tftp service bind port (default 69).
#   [*options*]: tftp service bind port (default 69).
#   [*inetd*]: Run as an xinetd service instead of standalone daemon (false)
# inetd options
#   [*inetd_ipv4*]: enable IPv4 for xinetd (true)
#   [*inetd_ipv6*]: enable IPv6 for xinetd (false)
#   [*inetd_instances*]: Number of instances for xinetd
#   [*inetd_user*]: user name for inetd (default root) if inetd enabled
#
# Actions:
#
# Requires:
#
#   Class['xinetd']  (if inetd set to true)
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
  $username        = $tftp::params::username,
  $directory       = $tftp::params::directory,
  $address         = $tftp::params::address,
  $address_ipv6    = $tftp::params::address_ipv6,
  $port            = $tftp::params::port,
  $options         = $tftp::params::options,
  $package         = $tftp::params::package,
  $binary          = $tftp::params::binary,
  $defaults        = $tftp::params::defaults,
  $inetd           = $tftp::params::inetd,
  $inetd_instances = $tftp::params::inetd_instances,
  $inetd_ipv4      = $tftp::params::address,
  $inetd_ipv6      = $tftp::params::inetd_ipv6,
  $inetd_user      = $tftp::params::inetd_user,
) inherits tftp::params {
  $virtual_package = 'tftpd-hpa'

  package { $virtual_package:
    ensure => present,
    name   => $package,
  }

  if $defaults {
    file { '/etc/default/tftpd-hpa':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('tftp/tftpd-hpa.erb'),
      require => Package[$virtual_package],
      notify  => Service['tftpd-hpa'],
    }
  }

  if $inetd {
    include ::xinetd
    # dedicated instances for IPv4 and IPv6
    if $inetd_ipv4 {
      xinetd::service { 'tftp':
        port         => $port,
        protocol     => 'udp',
        server_args  => "${options} -u ${username} ${directory}",
        server       => $binary,
        bind         => $address,
        socket_type  => 'dgram',
        cps          => '100 2',
        flags        => 'IPv4',
        per_source   => '11',
        wait         => 'yes',
        service_name => 'tftp',
        user         => $inetd_user,
        instances    => $inetd_instances,
        require      => Package[$virtual_package],
      }
    }
    if $inetd_ipv6 {
      xinetd::service { 'tftp-ipv6':
        port         => $port,
        protocol     => 'udp',
        server_args  => "${options} -u ${username} ${directory}",
        server       => $binary,
        bind         => $address_ipv6,
        socket_type  => 'dgram',
        cps          => '100 2',
        flags        => 'IPv6',
        per_source   => '11',
        wait         => 'yes',
        service_name => 'tftp',
        user         => $inetd_user,
        instances    => $inetd_instances,
        require      => Package[$virtual_package],
      }
    }

    $svc_ensure = stopped
    $svc_enable = false
  } else {
    $svc_ensure = running
    $svc_enable = true
  }

  $start = $tftp::params::provider ? {
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
