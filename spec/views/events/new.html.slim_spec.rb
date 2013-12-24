require 'spec_helper'

describe "events/new" do
  before(:each) do
    assign(:event, stub_model(Event,
      :title => "MyString",
      :poster => "MyString",
      :user_id => 1,
      :description => "MyText",
      :price => "9.99",
      :address => "MyString"
    ).as_new_record)
  end

  it "renders new event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", events_path, "post" do
      assert_select "input#event_title[name=?]", "event[title]"
      assert_select "input#event_remote_poster_url[name=?]", "event[remote_poster_url]"
      assert_select "textarea#event_description[name=?]", "event[description]"
      assert_select "input#event_price[name=?]", "event[price]"
      assert_select "input#event_address[name=?]", "event[address]"
    end
  end
end
