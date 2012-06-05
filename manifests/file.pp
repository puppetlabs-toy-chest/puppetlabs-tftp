# Define: tftp::file
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Usage:
#
define tftp::file (
  $ensure  = file,
  $recurse = false,
  $owner   = 'tftp',
  $group   = 'tftp',
  $mode    = '0644',
  $content = undef,
  $source  = undef
) {
  include 'tftp'

  file { "${tftp::directory}/${name}":
    ensure  => $ensure,
    recurse => $recurse,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    source  => $source,
    require => Class['tftp'],
  }
}
