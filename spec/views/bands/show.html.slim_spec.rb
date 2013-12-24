require 'spec_helper'

describe "bands/show" do
  before(:each) do
    @band = assign(:band, stub_model(Band,
      :name => "Name",
      :location => "Location",
      :city => "City",
      :country_name => "Country Name",
      :country_code => "Country Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Country Name/)
    expect(rendered).to match(/Country Code/)
  end
end
