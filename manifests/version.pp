define perl::version(
  $ensure    = 'installed',
  $configure = undef,
  $version   = $name,
) {
  require perl

  $dest = "${perl::root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true,
    }
  }
  else {
    $opts = $configure ? {
      undef   => '-Dusethreads',
      default => $configure,
    }

    $env = [ "PLENV_ROOT=${perl::root}" ]

    exec { "perl-install-${version}":
      command  => "${perl::root}/bin/plenv install ${version} ${opts}",
      cwd      => "${perl::root}/versions",
      provider => 'shell',
      timeout  => 0,
      creates  => $dest,
    }

    Exec["perl-install-${version}"] { environment +> $env }

   exec { 'plenv-install-cpanm':
      command => "env PLENV_ROOT=${perl::root} ${perl::root}/bin/plenv install-cpanm",
      unless  => "grep /opt/boxen/plenv/bin/plenv ${root}/shims/cpanm",
      require => Exec["perl-install-${version}"],
   }

    perl::cpan {
      "carton for ${version}":
        cpan => 'Carton',
        perl => $version ;
      "pm-uninstall for ${version}":
        cpan => 'App::pmuninsetall',
        perl => $version ;
    }
  }
}

