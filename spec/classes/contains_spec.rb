# To check the correct dependencies are set up for cfssl.

require 'spec_helper'
describe 'cfssl' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      describe 'Testing the dependencies between the classes' do
        it {
          is_expected.to contain_class('cfssl::install')
        }
        it {
          is_expected.to contain_class('cfssl::config')
        }
        it {
          is_expected.to contain_class('cfssl::service')
        }
        it {
          is_expected.to contain_class('cfssl::firewall')
        }

        it {
          is_expected.to contain_class('cfssl::install').that_comes_before('Class[cfssl::config]')
        }
        it {
          is_expected.to contain_class('cfssl::config').that_notifies('Class[cfssl::service]')
        }
        it {
          is_expected.to contain_class('cfssl::service').that_comes_before('Class[cfssl::firewall]')
        }
      end
    end
  end
end
