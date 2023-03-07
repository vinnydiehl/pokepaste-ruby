require "spec_helper"

describe PokePaste do
  let(:paste) { PokePaste::parse TEST_PASTE }

  describe "#parse" do
    TEST_DATA.each_with_index do |attrs, i|
      attrs.each do |attr, value|
        it "processes :#{attr}#{attr == :shiny ? '?' : ''} correctly" do
          attr = (attr.to_s + "?").to_sym if attr == :shiny
          expect(paste[i].send attr).to eq value
        end
      end
    end
  end

  describe "#fetch" do
    before :each do
      # stub a PokéPaste request
    end

    it "works with a full URL" do
      fetch = PokePaste::fetch TEST_PASTE_URL

      test_paste_equality paste, fetch
    end

    it "works with a path" do
      fetch = PokePaste::fetch "/#{TEST_PASTE_ID}"

      test_paste_equality paste, fetch
    end

    it "works with an ID" do
      fetch = PokePaste::fetch TEST_PASTE_ID

      test_paste_equality paste, fetch
    end

    it "fails with an invalid host or no path" do
      ["https://google.com/",
       "https://pokepast.es",
       "http://localhost/test"].each do |input|
        expect { PokePaste::fetch input }.to raise_error ArgumentError
      end
    end

    it "fails with an invalid input" do
      ["https://pokepast.es/nobodyhome",
       "somerandomtext",
       "https://pokepast.es/syntax.html",
       "syntax.html"].each do |input|
        expect { PokePaste::fetch input }.to raise_error OpenURI::HTTPError
      end
    end
  end
end
