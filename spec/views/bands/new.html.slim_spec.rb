require 'spec_helper'

describe "bands/new" do
  before(:each) do
    assign(:band, stub_model(Band,
      :name => "MyString",
      :location => "MyString",
      :city => "MyString",
      :country_name => "MyString",
      :country_code => "MyString"
    ).as_new_record)
  end

  it "renders new band form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", bands_path, "post" do
      assert_select "input#band_name[name=?]", "band[name]"
      assert_select "input#band_location[name=?]", "band[location]"
    end
  end
end
