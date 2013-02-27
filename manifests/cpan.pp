define perl::cpan( $cpan, $perl ) {
  require perl

  plenv_cpanm { $name:
    cpan          => $cpan,
    plenv_root    => $perl::root,
    plenv_version => $perl,
  }
}
