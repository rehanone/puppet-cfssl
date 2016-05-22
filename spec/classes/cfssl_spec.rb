require 'spec_helper'

describe 'cfssl' do

  let(:facts) { {
    :operatingsystem => 'Ubuntu',
    :kernel => 'Linux'
  } }

  it { should compile }

  context 'with default values for all parameters' do
    it { should contain_class('cfssl::install') }
    it { should contain_class('cfssl::config') }
    it { should contain_class('cfssl::service') }
    it { should contain_class('cfssl::firewall') }
  end
end
