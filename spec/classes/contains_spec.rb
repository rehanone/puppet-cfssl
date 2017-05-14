# To check the correct dependencies are set up for cfssl.

require 'spec_helper'
describe 'cfssl' do
  let(:facts) {{ :is_virtual => 'false' }}

  on_supported_os.select { |_, f| f[:os]['family'] != 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      it { is_expected.to compile.with_all_deps }
      describe "Testing the dependencies between the classes" do
        it { should contain_class('cfssl::install') }
        it { should contain_class('cfssl::config') }
        it { should contain_class('cfssl::service') }
        it { should contain_class('cfssl::firewall') }

        it { is_expected.to contain_class('cfssl::install').that_comes_before('Class[cfssl::config]') }
        it { is_expected.to contain_class('cfssl::config').that_notifies('Class[cfssl::service]') }
        it { is_expected.to contain_class('cfssl::service').that_comes_before('Class[cfssl::firewall]') }
      end
    end
  end
end
