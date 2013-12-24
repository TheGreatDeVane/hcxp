require 'spec_helper'

describe "bands/index" do
  before(:each) do
    assign(:bands, [
      stub_model(Band,
        :name => "Name",
        :location => "Location",
        :city => "City",
        :country_name => "Country Name",
        :country_code => "Country Code"
      ),
      stub_model(Band,
        :name => "Name",
        :location => "Location",
        :city => "City",
        :country_name => "Country Name",
        :country_code => "Country Code"
      )
    ])
  end

  it "renders a list of bands" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Country Name".to_s, :count => 2
    assert_select "tr>td", :text => "Country Code".to_s, :count => 2
  end
end
