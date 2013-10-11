require 'spec_helper'

describe 'perl::cpanm' do
  let(:facts) { default_test_facts }
  
  let(:title) { "carton for 5.18.1" }

  let(:params) do
    {
      :module => 'Carton',
      :perl   => '5.18.1'
    }
  end

  it do
    should include_class('perl')

    should contain_plenv_cpanm('carton for 5.18.1').with({
      :module        => 'Carton',
      :plenv_root    => '/test/boxen/plenv',
      :plenv_version => '5.18.1'
    })
  end
end

