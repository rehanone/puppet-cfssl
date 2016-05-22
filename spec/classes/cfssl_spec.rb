require 'spec_helper'

describe 'cfssl' do

  let(:facts) { {
    :operatingsystem => 'Ubuntu',
    :kernel => 'Linux'
  } }

  it { should compile }

  context 'with default values for all parameters' do
    it { should contain_class('cfssl::install') }
    it { should contain_class('cfssl::config').that_requires('Cfssl::Install') }
    it { should contain_class('cfssl::service').that_subscribes_to('Cfssl::Config') }
    it { should contain_class('cfssl::firewall').that_requires('Cfssl::Service') }
  end
end
