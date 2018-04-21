require 'spec_helper'
describe 'cfssl' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'cfssl::install', type: :class do
        let :pre_condition do
          'class { "cfssl": }'
        end

        it {
          is_expected.to contain_file('/opt/cfssl')
            .with_ensure('directory')
            .with_owner('root')
            .with_group('root')
            .with_mode('0755')
        }

        it {
          is_expected.to contain_class('wget')
        }

        it {
          is_expected.to have_wget__retrieve_resource_count(8)
        }
      end
    end
  end
end
