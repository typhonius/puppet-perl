# Public: Configuration values for perl
class perl::params {
  case $::osfamily {
    'Darwin': {
      include boxen::config

      $plenv_root = "${boxen::config::home}/plenv"
      $user       = $::boxen_user
    }

    default: {
      $plenv_root = '/usr/local/share/plenv'
      $user       = 'root'
    }
  }

  $plenv_version  = '2.1.1'

  $default_cpanm  = ['Carton']

  $plenv_plugins  = {
    'perl-build' => {
      'ensure' => '1.05'
      'source' => 'tokuhirom/Perl-Build'
    }    
  }
}
