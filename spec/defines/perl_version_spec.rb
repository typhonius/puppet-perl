require 'spec_helper'

describe 'perl::version' do
  let(:facts) { default_test_facts }
  let(:title) { '5.18.1' }

  context "ensure => present" do
    context "default params" do
      it do
        should include_class('perl')

        should contain_exec('perl-install-5.18.1').with({
          :command  => "/test/boxen/plenv/bin/plenv install 5.18.1 ",
          :cwd      => '/test/boxen/plenv/versions',
          :provider => 'shell',
          :timeout  => 0,
          :creates  => '/test/boxen/plenv/versions/5.18.1'
        })
      end
    end

    context "when env is default" do
      it do
        should contain_exec('perl-install-5.18.1').with_environment([
          "CC=/usr/bin/cc",
          "PLENV_ROOT=/test/boxen/plenv"
        ])
      end
    end

    context "when env is not nil" do
      let(:params) do
        {
          :env => { 'SOME_VAR' => 'flocka' }
        }
      end

      it do
        should contain_exec('perl-install-5.18.1').with_environment([
          "CC=/usr/bin/cc",
          "PLENV_ROOT=/test/boxen/plenv",
          "SOME_VAR=flocka"
        ])
      end
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end

    it do
      should contain_file('/test/boxen/plenv/versions/5.18.1').with({
        :ensure => 'absent',
        :force  => true
      })
    end
  end
end
