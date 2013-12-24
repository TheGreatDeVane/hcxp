require 'spec_helper'

describe Venue do
  before(:each) do
    @venue = FactoryGirl.build(:venue)
  end

  it "has a valid factory" do
    expect(@venue).to be_valid
  end

  it "is invalid without a name" do
    @venue.name = nil
    expect(@venue).to_not be_valid
  end

  context "with address given" do
    it "has a proper geo params" do
      @venue.address = 'Warszawska 1, Krakow, Poland'
      @venue.save!

      expect(@venue.country_name).to eq 'Poland'
      expect(@venue.city).to         eq 'Krakow'
      expect(@venue.street).to       eq 'Warszawska 1'
      expect(@venue.latitude).to     eq 50.0680927
      expect(@venue.longitude).to    eq 19.9431451
    end

    it "is invalid without any geo data" do
      @venue.address = 'agagwa, awagwa, awgwagwa'
      expect(@venue).to_not be_valid
    end

    # Make it able to improve venue place by dragging a map pointer
    # without changing the actual adress.
    context "while lat/long has been changed" do
      it "has the same geo data as before the lat/long change" do
        @venue.address = 'Warszawska 1, Krakow, Poland'
        @venue.save
        existing_event = Venue.last
        edited_event   = Venue.last
        edited_event.update_attribute(:longitude, existing_event.longitude * 2)
        
        expect(edited_event.country_name).to  eq existing_event.country_name
        expect(edited_event.city).to          eq existing_event.city
        expect(edited_event.street).to        eq existing_event.street
        expect(edited_event.longitude).to_not eq existing_event.longitude
      end
    end
  end
end
