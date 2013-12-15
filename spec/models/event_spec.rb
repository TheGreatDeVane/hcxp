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

  context "with address given" do
    it "has a proper geo params" do
      @event.address = 'Warszawska 1, Krakow, Poland'
      @event.save!

      expect(@event.country_name).to eq 'Poland'
      expect(@event.city).to         eq 'Krakow'
      expect(@event.street).to       eq 'Warszawska 1'
      expect(@event.latitude).to     eq 50.0680927
      expect(@event.longitude).to    eq 19.9431451
    end

    it "is invalid without any geo data" do
      @event.address = 'agagwa, awagwa, awgwagwa'
      expect(@event).to_not be_valid
    end

    # Make it able to improve venue place by dragging a map pointer
    # without changing the actual adress.
    context "while lat/long has been changed" do
      it "has the same geo data as before the lat/long change" do
        @event.address = 'Warszawska 1, Krakow, Poland'
        @event.save
        existing_event = Event.last
        edited_event   = Event.last
        edited_event.update_attribute(:longitude, existing_event.longitude * 2)
        
        expect(edited_event.country_name).to  eq existing_event.country_name
        expect(edited_event.city).to          eq existing_event.city
        expect(edited_event.street).to        eq existing_event.street
        expect(edited_event.longitude).to_not eq existing_event.longitude
      end
    end
  end

end
