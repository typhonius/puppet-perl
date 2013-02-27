class perl::global( $version = '5.16.2' ) {
  if $version != 'system' {
    require join( ['perl', join( split($version, '[.]'), '-')], '::')
  }

  file { "${perl::root}/version":
    ensure  => present,
    owner   => $::boxen_user,
    mode    => '0644',
    content => "${version}\n",
  }
}
