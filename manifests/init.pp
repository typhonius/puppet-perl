# Class: perl
#
# This module installs a full plenv-driven perl stack
#
class perl(
  $plenv_plugins = {},
  $plenv_version = $perl::params::plenv_version,
  $plenv_root    = $perl::params::plenv_root,
  $user          = $perl::params::user
) inherits perl::params {
  
  if $::osfamily == 'Darwin' {
    include boxen::config

    file { "${boxen::config::envdir}/plenv.sh":
      source => 'puppet:///modules/perl/plenv.sh' ;
    }
  }

  repository { $plenv_root:
    ensure => $plenv_version,
    source => 'tokuhirom/plenv',
    user   => $user
  }

  file {
    [
      "${plenv_root}/plugins",
      "${plenv_root}/plenv.d",
      "${plenv_root}/shims",
      "${plenv_root}/versions",
    ]:
      ensure  => directory,
      require => Repository[$plenv_root];
  }

  $_real_plenv_plugins = merge($perl::params::plenv_plugins, $plenv_plugins)
  create_resources('perl::plugin', $_real_plenv_plugins)

  Repository[$plenv_root] ->
    Perl::Plugin <| |> ->
    Perl::Version <| |>
}
