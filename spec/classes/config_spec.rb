require 'spec_helper'
describe 'cfssl' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'cfssl::config', type: :class do
        let :pre_condition do
          'class { "cfssl": ca_manage => true }'
        end

        let(:facts) do
          {
            os: { 'name' => 'Ubuntu' },
            osfamily: 'Debian',
            puppetversion: '4.0.0',
            lsbdistid: 'debian',
          }
        end

        it { is_expected.to have_resource_count(49) }

        it { is_expected.to have_class_count(9) }

        it { is_expected.to have_cfssl__ca_resource_count(2) }

        it {
          is_expected.to contain_cfssl__ca('ca')
            .with_common_name('My Root CA')
            .with_ca_expire('262800h')
        }

        it {
          is_expected.to contain_cfssl__ca('intermediate-ca')
            .with_common_name('My Intermediate CA')
            .with_ca_expire('42720h')
        }

        it {
          is_expected.to contain_file('/etc/cfssl/signing.json')
            .with_ensure('file')
        }

        it {
          is_expected.to have_cfssl__sign_resource_count(1)
        }

        it {
          is_expected.to contain_cfssl__sign('intermediate-ca-signed')
            .with_ca_id('ca')
            .with_csr_file('/etc/cfssl/intermediate-ca.csr')
            .with_profile('ca')
        }

        it {
          is_expected.to contain_exec('intermediate-ca-to-ca-chain')
            .with_command('cat intermediate-ca-signed.pem ca.pem > /etc/cfssl/chain.pem')
            .with_cwd('/etc/cfssl')
            .with_creates('["/etc/cfssl/chain.pem"]')
            .with_provider('shell')
            .with_path('["/sbin", "/bin"]')
            .with_timeout('0')
            .with_logoutput('true')
        }
      end
    end
  end
end
