require 'spec_helper'

describe Band do
  before(:each) do
    @band = FactoryGirl.build(:band)
  end

  it "has a valid factory" do
    expect(@band).to be_valid
  end

  it "is invalid without a name" do
    @band.name = nil
    expect(@band).to_not be_valid
  end

  it "is invalid without a location" do
    @band.location = nil
    expect(@band).to_not be_valid
  end
end
