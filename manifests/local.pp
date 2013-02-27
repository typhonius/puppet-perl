define perl::local($version = undef, $ensure = present) {
  if $version != 'system' and $ensure == present {
    require join(['perl', join( split($version),'[.-]', '_' )], '::')
  }

  file { "${name}/.ruby-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true,
  }
}
