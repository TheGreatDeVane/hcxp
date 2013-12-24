require 'spec_helper'

describe Save do
  before(:each) do
    @save = FactoryGirl.build(:save)
  end

  it "has a valid factory" do
    expect(@save).to be_valid
  end

  it "is invalid without a user_id" do
    @save.user_id = nil
    expect(@save).to_not be_valid
  end

  it "is invalid without a event_id" do
    @save.event_id = nil
    expect(@save).to_not be_valid
  end
end
