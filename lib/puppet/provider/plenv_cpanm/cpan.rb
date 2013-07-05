require 'puppet/util/execution'

Puppet::Type.type(:plenv_cpanm).provide(:cpan) do
  include Puppet::Util::Execution
  desc ""

  def path
    [
      "#{@resource[:plenv_root]}/bin",
      "#{@resource[:plenv_root]}/shims",
      "#{Facter[:boxen_home].value}/homebrew/bin",
    ].join(':')
  end

  def plenv_command(command)
    full_command = [
      "sudo -u #{Facter[:luser].value}",
      "PATH=#{path}",
      "PLENV_VERSION=#{@resource[:plenv_version]}",
      "PLENV_ROOT=#{@resource[:plenv_root]}",
      "#{@resource[:plenv_root]}/bin/plenv exec #{command}",
    ].join(' ')

    output = `#{full_command}`
    [ output, $? ]
  end

  def create
    plenv_command "cpanm #{@resource[:cpan]}"
  end

  def destory 
    plenv_command "pm-uninstall #{@resource[:cpan]}"
  end

  def exists?
    ret = plenv_command "perl -MExtUtils::Installed -e 'exit(scalar(grep { $_ eq q{#{@resource[:cpan]}} } ExtUtils::Installed->new->modules()) ? 0 : 1 )'"
    return ( ret[1] == 0 ) ? true : false ;
  end

end




