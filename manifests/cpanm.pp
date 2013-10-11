# Installs a CPAN module for specific version of perl managed by plenv.
#
# Usage:
#
#     perl::cpanm { 'carton for 5.18.1':
#       module => 'Carton',
#       perl   => '5.18.1',
#     }
define perl::cpanm( $module, $perl, $ensure => 'present' ) {
  require perl

  plenv_cpanm { $name:
    ensure        => $ensure,
    module        => $module,
    plenv_root    => $perl::plenv_root,
    plenv_version => $perl,
  }
}
