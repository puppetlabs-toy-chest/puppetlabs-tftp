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
  $owner        = 'tftp',
  $group        = 'tftp',
  $mode         = '0644',
  $recurse      = false,
  $purge        = undef,
  $replace      = undef,
  $recurselimit = undef,
  $content      = undef,
  $source       = undef
) {
  include 'tftp'

  if $source {
    $source_real = $source
  } elsif $ensure != 'directory' and ! $content {
    if $caller_module_name {
      $mod = $caller_module_name
    } else {
      $mod = $module_name
    }
    $source_real = "puppet:///modules/${mod}/${name}"
  }

  file { "${tftp::directory}/${name}":
    ensure       => $ensure,
    owner        => $owner,
    group        => $group,
    mode         => $mode,
    recurse      => $recurse,
    purge        => $purge,
    replace      => $replace,
    recurselimit => $recurselimit,
    content      => $content,
    source       => $source_real,
    require      => Class['tftp'],
  }
}
