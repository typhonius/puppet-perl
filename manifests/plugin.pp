# Public: Install an plenv plugin
#
# Usage:
#
#    perl::plugin { 'perl-build':
#      ensure => '1.05',
#      source => 'tokuhirom/Perl-Build'
#    }

define perl::plugin($ensure, $source) {
  include perl

  repository { "${perl::plenv_root}/plugins/${name}":
    ensure => $ensure,
    force  => true,
    source => $source,
    user   => $perl::user
  }
}
