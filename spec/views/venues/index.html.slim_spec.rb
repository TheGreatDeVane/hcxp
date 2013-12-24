require 'spec_helper'

describe "venues/index" do
  before(:each) do
    assign(:venues, [
      stub_model(Venue,
        :name => "Name",
        :address => "Address",
        :street => "Street",
        :city => "City",
        :country_name => "Country Name",
        :country_code => "Country Code"
      ),
      stub_model(Venue,
        :name => "Name",
        :address => "Address",
        :street => "Street",
        :city => "City",
        :country_name => "Country Name",
        :country_code => "Country Code"
      )
    ])
  end

  it "renders a list of venues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Street".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Country Name".to_s, :count => 2
    assert_select "tr>td", :text => "Country Code".to_s, :count => 2
  end
end
