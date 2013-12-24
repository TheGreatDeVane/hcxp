require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the EventsHelper. For example:
#
# describe EventsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe EventsHelper do
  describe "event_date_to_words" do
    it "returns Yesterday when needed" do
      date = DateTime.now - 1.day
      expect(helper.event_date_to_words date).to eq 'Yesterday'
    end

    it "returns Tomorrow when needed" do
      date = DateTime.now + 1.day
      expect(helper.event_date_to_words date).to eq 'Tomorrow'
    end

    it "returns Tomorrow when needed" do
      date = DateTime.now
      expect(helper.event_date_to_words date).to eq 'Today'
    end

    it "returns a date if needed" do
      date = DateTime.now + 10.days
      expect(helper.event_date_to_words date).to eq date.strftime('%d.%m.%Y')
    end
  end
end
