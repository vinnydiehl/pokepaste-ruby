require "spec_helper"

# For most of these the species doesn't matter, here's a shortcut
def init_pkmn(**args)
  PokePaste::Pokemon.new species: "Bulbasaur", **args
end

GENDERS = {m: :male, f: :female}

describe PokePaste::Pokemon do
  context "when initialized with no species" do
    it "throws an ArgumentError" do
      expect { PokePaste::Pokemon.new }.to raise_error ArgumentError
    end
  end

  %i[evs ivs shiny level happiness moves].each do |attr|
    context "when initiaized with an invalid type for :#{attr}" do
      it "throws a TypeError" do
        expect { init_pkmn attr => "string" }.to raise_error TypeError
      end
    end
  end

  GENDERS.each do |shorthand, gender|
    context "when gender :#{shorthand} is used" do
      it "expands it to :#{gender}" do
        expect(init_pkmn(gender: shorthand).gender).to eq gender
      end
    end

    context "when a string '#{gender}' is used" do
      it "changes it to a symbol" do
        expect(init_pkmn(gender: gender.to_s).gender).to eq gender
      end
    end

    context "when a string '#{shorthand}' is used" do
      it "changes it to the symbol :#{gender}" do
        expect(init_pkmn(gender: shorthand.to_s).gender).to eq gender
      end
    end
  end

  context "when a gender unavailable in the Pokémon games is used" do
    it "raises a typeerror" do
      expect { init_pkmn gender: :test }.to raise_error TypeError
    end
  end

  it "downcases the gender" do
    expect(init_pkmn(gender: "Male").gender).to eq :male
  end

  context "when you try to pass in a boolean for the nature" do
    it "raises a typeerror" do
      expect { init_pkmn nature: true }.to raise_error TypeError
    end
  end

  context "when you pass a string in for the nature" do
    it "converts it to a lowercase symbol" do
      expect(init_pkmn(nature: "Bold").nature).to eq :bold
    end
  end

  %i[evs ivs].each do |attr|
    # n is the default
    n = attr == :evs ? 0 : 31
    attr_title = attr.to_s.chop.upcase

    context "when given a single #{attr_title}" do
      it "keeps the rest of the #{attr_title}s at their defaults" do
        expect(init_pkmn(attr => {hp: 10}).send attr).to eq({
          hp: 10, atk: n, def: n, spa: n, spd: n, spe: n
        })
      end
    end
  end

  context "when initialized with only a species" do
    let(:pkmn) { PokePaste::Pokemon.new(species: "Armarouge") }

    # The second 'mon in the test data is an Armarouge with
    # all default values, nothing set except the species.
    TEST_DATA[1].each do |attr, value|
      it "sets the :#{attr} attribute correctly" do
        expect(pkmn.send attr).to eq value
      end
    end
  end
end
