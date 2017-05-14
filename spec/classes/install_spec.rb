require 'spec_helper'
describe 'cfssl' do
  let(:facts) {{ :is_virtual => 'false' }}

  on_supported_os.select { |_, f| f[:os]['family'] != 'Solaris' }.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      describe 'cfssl::install', :type => :class do
        let :pre_condition do
            'class { "cfssl": }'
        end

        it { is_expected.to contain_file('/opt/cfssl')
          .with_ensure('directory')
          .with_owner('root')
          .with_group('root')
          .with_mode('0755')
        }

        it { is_expected.to contain_class('wget') }

        it { is_expected.to have_wget__retrieve_resource_count(8) }
      end
    end
  end
end
