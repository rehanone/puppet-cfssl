require 'spec_helper'

describe 'cfssl::params', :type => :class do

  it { is_expected.to contain_cfssl__params }

  it "Should not contain any resources" do
    expect(subject.call.resources.size).to eq(4)
  end
end
