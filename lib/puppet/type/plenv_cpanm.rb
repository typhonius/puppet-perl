Puppet::Type.newtype(:plenv_cpanm) do
  @doc = ""

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end
  end

  newparam(:name) do
    isnamevar
  end

  newparam(:cpan) do
  end

  newparam(:plenv_version) do
  end

  newparam(:plenv_root) do
  end

  autorequire(:exec) do
    "perl-install-#{self[:plenv_version]}"
  end
end

