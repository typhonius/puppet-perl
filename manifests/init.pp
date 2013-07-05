class perl {
  include boxen::config
  include homebrew

  $root = "${boxen::config::home}/plenv"
  $plenv_version = '2.0.1'

  package { 'plenv': ensure => absent; }

  file {
    $root:
      ensure => directory ;

    [
      "${root}/shims",
      "${root}/versions",
    ]:
      ensure  => directory,
      require => Exec['plenv-setup-root-repo'] ;

    "${boxen::config::envdir}/plenv.sh":
      source  => 'puppet:///modules/perl/plenv.sh' ;
  }

  $git_init   = 'git init .'
  $git_remote = 'git remote add origin https://github.com/tokuhirom/plenv.git'
  $git_fetch  = 'git fetch -q origin'
  $git_reset  = "git reset --hard ${plenv_version}"

  exec { 'plenv-setup-root-repo':
    command => "${git_init} && ${git_remote} && ${git_fetch} && ${git_reset}",
    cwd     => $root,
    creates => "${root}/bin/plenv",
    require => [ File[$root], Class['git'] ]
  }

  exec { 'plenv-install-perl-build':
    command => "git clone https://github.com/tokuhirom/Perl-Build.git ${root}/plugins/perl-build/"
    cwd     => $root,
    creates => "${root}/plugins/perl-build/bin/perl-build"
    require => Exec['plenv-setup-root-repo']
  }

  exec { "ensure-plenv-version-${plenv_version}":
    command => "${git_fetch} && ${git_reset}",
    unless  => "git describe --tags --exact-match `git rev-parse HEAD` | grep ${plenv_version}",
    cwd     => $root,
    require => Exec['plenv-install-perl-build']
  }

  exec { 'plenv-install-cpanm':
    command => "env PLENV_ROOT=${root} ${root}/bin/plenv install-cpanm",
    unless  => "grep /opt/boxen/plenv/bin/plenv ${root}/shims/cpanm",
    require => Exec["plenv-rehash-post-install"],
  }

  exec { 'plenv-rehash-post-install':
    command => "/bin/rm -rf ${root}/shims && PLENV_ROOT=${root} ${root}/bin/plenv rehash",
    unless  => "grep /opt/boxen/plenv/bin/plenv ${root}/shims/cpan",
    require => Exec["ensure-plenv-version-${plenv_version}"],
  }
}
