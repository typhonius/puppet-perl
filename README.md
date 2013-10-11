# Perl Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxelly/puppet-perl.png?branch=master)](https://travis-ci.org/boxelly/puppet-perl)

use Perl with [plenv](https://github.com/tokuhirom/plenv)!

## Usage

```puppet
# Set the global default perl (auto installs it if it can)
class { 'perl::global':
  version => '5.18.1'
}

# ensure a certain perl version is used in a dir
perl::local { '/path/to/some/project':
  version => '5.8.9'
}

# ensure a CPAN module is installed for a certain perl version
# NOTE: you can't have duplicate resource name so you have to name like  so
$version = '5.18.1'
perl::cpanm { "carton for ${version}":
  module => 'Carton',
  perl   => $version
}

# install a perl version
perl::version { '5.18.1' }

# install plenv plugin
perl::plugin { 'plenv-contrib':
  ensure => present,
  source => 'miyagawa/plenv-contrib'
}
```

## Required Puppet Modules

* `boxen`
* `repository >= 2.1`
* `xquartz` (OSX only)

