# Public: specify the global perl version as per plenv
#
# Usage:
#
#     class { 'perl::global': version => '5.18.1' }

class perl::global($version = '5.18.1') {
  include perl

  file { "${perl::plenv_root}/version":
    ensure  => present,
    owner   => $perl::user,
    mode    => '0644',
    content => "${version}\n",
  }
}
