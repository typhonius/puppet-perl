require 'puppet/util/execution'

Puppet::Type.type(:plenv_cpanm).provide(:cpanm) do
  include Puppet::Util::Execution
  desc ""

  def path
    [
      "#{@resource[:plenv_root]}/bin",
      "#{@resource[:plenv_root]}/plugin/perl-build/bin",
      "#{@resource[:plenv_root]}/shims",
      "#{Facter[:boxen_home].value}/homebrew/bin",
      "$PATH"
    ].join(':')
  end

  def plenv_cpanm(command)
    full_command = [
      "sudo -u #{Facter[:boxen_user].value}",
      "PATH=#{path}",
      "PLENV_VERSION=#{@resource[:plenv_version]}",
      "PLENV_ROOT=#{@resource[:plenv_root]}",
      "#{@resource[:plenv_root]}/shims/cpanm #{command}"
    ].join(" ")
  
    output = `#{full_command}`
    [ output, $? ]
  end

  def create
    plenv_cpanm "--install #{@resource[:module]}"
  end

  def destroy
    plenv_cpanm "--uninstall #{@resource[:module]}"
  end

  def exists?
    root     = "#{@resource[:plenv_root]}/versions/#{@resource[:plenv_version]}/lib/perl5"
    filename = @resource[:module].gsub(/::/, "/")

    return Dir.glob("#{root}/**/#{filename}.pm").length > 0
  end
end
