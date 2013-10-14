# Install a perl version via plenv
# Takes ensure, env, configure, and version params.
#
# Usage:
#
#     perl::version { '5.18.1': }
define perl::version(
  $ensure    = 'installed',
  $env       = {},
  $configure = '',
  $version   = $name,
) {
  require perl

  case $::operatingsystem {
    'Darwin': {
      require xquartz

      $os_env = {
        'CFLAGS' => '-I/opt/X11/include'
      }
    }

    default: {
      $os_env = {}
    }
  }

  $dest = "${perl::plenv_root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true
    }
  } else {
    $default_env = {
      'CC'         => '/usr/bin/cc',
      'PLENV_ROOT' => $perl::plenv_root
    }

    $final_env   = merge( merge( $default_env, $os_env ), $env )

    exec { "perl-install-${version}":
      command  => "${perl::plenv_root}/bin/plenv install ${version} ${configure}",
      cwd      => "${perl::plenv_root}/versions",
      provider => 'shell',
      timeout  => 0,
      creates  => $dest,
      user     => $perl::user,
    }
    ->
    exec { "perl-install-cpanm-to-${version}":
      command  => "${perl::plenv_root}/bin/plenv install-cpanm",
      cwd      => $dest,
      timeout  => 0,
      creates  => "${perl::plenv_root}/shims/cpanm",
      user     => $perl::user,
    }
    ->
    perl::cpanm { "carton for ${version}":
      module  => 'Carton',
      perl    => $version,
    }

    Exec["perl-install-${version}"] {
      environment +> sort(join_keys_to_values($final_env, '='))
    }
  }
}

