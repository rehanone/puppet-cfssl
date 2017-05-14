require 'spec_helper'

describe 'cfssl' do
  let(:facts) {{ :is_virtual => 'false' }}

  on_supported_os.select { |_, f| f[:os]['family'] != 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      it { is_expected.to compile.with_all_deps }

      describe 'ensure wget is managed' do
        let(:params) {{ :wget_manage => true, }}

        it { should contain_package('wget').with(
          :ensure => 'present'
        )}

        describe 'ensure wget is not managed' do
          let(:params) {{ :wget_manage => false, }}
          #it { should_not contain_package('wget') }
        end
      end

    end
  end
end
