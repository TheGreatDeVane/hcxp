require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  it "has a valid factory" do
    expect(@user).to be_valid
  end

  it "is invalid without an email" do
    @user.email = nil
    expect(@user).to_not be_valid
  end

  it "is invalid without a username" do
    @user.username = nil
    expect(@user).to_not be_valid
  end

  it "is invalid with non-unique username" do
    taken_username = @user.username
    second_user = FactoryGirl.build(:user)
    second_user.username = taken_username
    expect(second_user).to_not be_valid
  end
end
