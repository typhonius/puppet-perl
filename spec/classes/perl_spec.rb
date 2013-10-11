require 'spec_helper'

describe 'perl' do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :plenv_plugins => {},
      :plenv_version => '2.1.1',
      :plenv_root    => '/test/boxen/plenv',
      :user          => 'boxenuser'
    }
  end

  let(:params) { default_params }

  it do
    should include_class("perl::params")

    should contain_repository('/test/boxen/plenv').with_ensure('2.1.1')

    should contain_file('/test/boxen/plenv/versions').with_ensure('directory')
    should contain_file('/test/boxen/plenv/plenv.d').with_ensure('directory')
    
    should include_class("boxen::config")

    should contain_file('/test/boxen/env.d/plenv.sh').
        with_source('puppet:///modules/perl/plenv.sh')

    should contain_perl__plugin('perl-build').with({
      :ensure => '1.05',
      :source => 'tokuhirom/Perl-Build'
    })
  end

  context "not darwin" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }
    
    it do
      should_not include_class("boxen::config")

      should_not contain_file('/test/boxen/env.d/plenv.sh').
        with_source('puppet:///modules/perl/plenv.sh')
    end
  end

  context "plenv plugins" do
    let(:params) do
      default_params.merge(
        :plenv_plugins => {
          'plenv-contrib' => {
            'ensure' => 'present',
            'source' => 'miyagawa/plenv-contrib'
           }
        }
      )
    end

    it do
      should contain_perl__plugin('plenv-contrib').with({
        :ensure => 'present',
        :source => 'miyagawa/plenv-contrib'
      })
    end
  end
end
