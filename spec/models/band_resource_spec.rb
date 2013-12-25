require 'spec_helper'

describe BandResource do
  before(:each) do
    @band = FactoryGirl.build(:band)
  end

  describe "as bandcamp link" do
    before(:each) do
      @resource = @band.resources.create(type: 'bandcamp', url: 'http://turnstilehc.bandcamp.com/')
    end
    
    it "has a valid factory" do
      expect(@band).to be_valid
    end
  end
end
