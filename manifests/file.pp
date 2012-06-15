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
  $ensure       = file,
  $recurse      = false,
  $purge        = undef,
  $replace      = undef,
  $recurselimit = undef,
  $owner        = 'tftp',
  $group        = 'tftp',
  $mode         = '0644',
  $content      = undef,
  $source       = undef
) {
  include 'tftp'

  file { "${tftp::directory}/${name}":
    ensure       => $ensure,
    recurse      => $recurse,
    purge        => $purge,
    replace      => $replace,
    recurselimit => $recurselimit,
    owner        => $owner,
    group        => $group,
    mode         => $mode,
    content      => $content,
    source       => $source,
    require      => Class['tftp'],
  }
}
