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
  $owner        = 'tftp',
  $group        = 'tftp',
  $mode         = '0644',
  $purge        = undef,
  $replace      = undef,
  $recurselimit = undef,
  $content      = undef,
  $source       = undef
) {
  include 'tftp'

  file { "${tftp::directory}/${name}":
    ensure       => $ensure,
    recurse      => $recurse,
    owner        => $owner,
    group        => $group,
    mode         => $mode,
    purge        => $purge,
    replace      => $replace,
    recurselimit => $recurselimit,
    content      => $content,
    source       => $source,
    require      => Class['tftp'],
  }
}
