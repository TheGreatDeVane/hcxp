require 'spec_helper'

describe Event do
  before(:each) do
    @event = FactoryGirl.build(:event)
  end

  it "has a valid factory" do
    expect(@event).to be_valid
  end

  it "is valid without a title" do
    @event.title = nil
    expect(@event).to be_valid
  end

  it "is valid without a description" do
    @event.description = nil
    expect(@event).to be_valid
  end

  it "is valid without a beginning_at date" do
    @event.beginning_at = nil
    expect(@event).to be_valid
  end

  it "is valid without a beginning_at_time" do
    @event.beginning_at_time = nil
    expect(@event).to be_valid
  end

  it "is valid without an address" do
    @event.address = nil
    expect(@event).to be_valid
  end

  it "is valid without a price" do
    @event.price = nil
    expect(@event).to be_valid
  end

  it "is valid without a ending_at date" do
    @event.ending_at = nil
    expect(@event).to be_valid
  end

  it "is valid without a ending_at_time" do
    @event.ending_at_time = nil
    expect(@event).to be_valid
  end

  it "is valid without a bands" do
    @event.band_list = nil
    expect(@event).to be_valid
  end

  it "is valid without a poster" do
    @event.poster = nil
    expect(@event).to be_valid
  end

  it "is invalid without an author" do
    @event.user_id = nil
    expect(@event).to_not be_valid
  end

end
