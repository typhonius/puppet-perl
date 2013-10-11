require 'spec_helper'

describe 'perl::local' do
  let(:facts) { default_test_facts }

  let(:title) { '/tmp' }

  context "ensure => present" do
    let(:params) do
      {
        :version => '5.18.1'
      }
    end

    it do
      should contain_file('/tmp/.perl-version').with({
        :ensure  => 'present',
        :content => "5.18.1\n",
        :replace => true
      })
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end

    it do
      should contain_file('/tmp/.perl-version').with_ensure('absent')
    end
  end
end
