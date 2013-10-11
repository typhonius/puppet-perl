require 'spec_helper'

describe "perl::plugin" do
  let(:facts) { default_test_facts }

  let(:title) { "plenv-contrib" }

  let(:params) do
    {
      :ensure => 'present',
      :source => 'miyagawa/plenv-contrib'
    }
  end

  it do
    should include_class('perl')

    should contain_repository('/test/boxen/plenv/plugins/plenv-contrib').with({
      :ensure => 'present',
      :source => 'miyagawa/plenv-contrib',
    })
  end
end

