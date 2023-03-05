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
end
