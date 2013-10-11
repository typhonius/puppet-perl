# Set a directory's default perl version via plenv.
# Automatically ensures that perl version is installed via plenv.
#
# Usage:
#
#    perl::local { '/path/to/a/project': version => '5.18.1' }

define perl::local(
    $version = undef,
    $ensure  = present
) {
  file { "${name}/.perl-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true ;
  }
}
