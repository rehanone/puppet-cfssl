require 'spec_helper'

describe 'cfssl' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      describe 'ensure wget is managed' do
        let(:params) do
          {
            wget_manage: true,
          }
        end

        it {
          is_expected.to contain_package('wget').with(
            ensure: 'present',
          )
        }
      end
    end
  end
end
