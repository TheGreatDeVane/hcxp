require 'spec_helper'

describe ThreadParser do
  describe '#initialize' do
    context "given regular thread url" do
      let(:object) { ThreadParser.new(url: "http://forum.hard-core.pl/viewtopic.php?f=4&t=56496") }
      it { expect(object.id).to   eq 56496 }
      it { expect(object.type).to eq 'thread' }
    end

    context "given post url" do
      let(:object) { ThreadParser.new(url: "http://forum.hard-core.pl/viewtopic.php?p=1182059#p1182059") }
      it { expect{ object.id }.to raise_error(WrongUrl) }
    end

    context "given thread id" do
      let(:object){ ThreadParser.new(id: 56496) }
      it { expect(object.url).to eq('http://forum.hard-core.pl/viewtopic.php?t=56496') }
    end

    context "given no id or url params" do
      let(:object) { ThreadParser.new() }
      it { expect{ object }.to raise_error(ArgumentError) }
    end
  end
end