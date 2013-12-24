require "spec_helper"

describe EventsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/e").to route_to("events#index")
    end

    it "routes to #new" do
      expect(:get => "/e/new").to route_to("events#new")
    end

    it "routes to #show" do
      expect(:get => "/e/1").to route_to("events#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/e/1/edit").to route_to("events#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/e").to route_to("events#create")
    end

    it "routes to #update" do
      expect(:put => "/e/1").to route_to("events#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/e/1").to route_to("events#destroy", :id => "1")
    end

  end
end
