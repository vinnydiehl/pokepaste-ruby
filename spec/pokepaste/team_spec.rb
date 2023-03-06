require "spec_helper"

describe PokePaste::Team do
  let :team do
    team = PokePaste::Team.new
    TEST_DATA.each { |pkmn| team << PokePaste::Pokemon.new(**pkmn) }
    team
  end

  describe "#to_s" do
    it "produces the correct PokéPaste" do
      expect(team.to_s).to eq TEST_PASTE
    end
  end

  describe "#<<" do
    context "when given a PokePaste::Pokemon" do
      it "adds it to the team" do
        orig_size = team.size
        team << PokePaste::Pokemon.new(species: (test_species = "Bulbasaur"))

        expect(team.size).to eq (orig_size + 1)
        expect(team.last.species).to eq test_species
      end
    end

    context "when given a string" do
      it "throws a TypeError" do
        expect { team << "string" }.to raise_error TypeError
      end
    end
  end
end
