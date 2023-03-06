require "pokepaste/paste"
require "pokepaste/pokemon"

module PokePaste
  def self.parse(paste)
    # Each paragraph is a Pokémon (separated by 1 or more blank lines)
    paragraphs = paste.split(/\n\s*\n/).map { |p| p.split("\n").map &:strip }

    team = PokePaste::Team.new

    paragraphs.each do |paragraph|
      # Line 1 can contain species, nickname, gender, and item in format like:
      #   Bud (Bulbasaur) (M) @ Life Orb
      # Only the species is required, however
      line1 = paragraph.shift
      before_at, item = line1.split /\s+@\s+/

      # Now work from right to left, parsing off the parts in parens

      # Set the gender to nil, :male, or :female
      if gender = before_at.slice!(/\s*\((m(ale)?|f(emale)?)\)$/i)
        # Get rid of the parens
        [/^\s*\(/, /\)$/].each { |regex| gender.slice! regex }
        gender = PokePaste::Pokemon.gender_abbrs[gender.downcase[0].to_sym]
      end

      # This regex requires a space between the nickname and opening paren
      if species = before_at.slice!(/\s+\([^\)]+\)$/i)
        # We found the species inside parens, which means a nickname is present
        [/^\s*\(/, /\)$/].each { |regex| species.slice! regex }
        nickname = before_at
      else
        # Otherwise all that remains is the species, and there is no nickname
        species = before_at
        nickname = nil
      end

      pkmn = PokePaste::Pokemon.new species: species, nickname: nickname,
                                    item: item, gender: gender

      # Pull the moves out
      pkmn.moves, paragraph = paragraph.partition { |line| line =~ /^\s*-/ }
      pkmn.moves.map! { |line| line.sub /^\s*-\s*/, "" } if pkmn.moves.any?

      # Pull the nature out. If there are multiple, the first is used
      nature_line, paragraph = paragraph.partition { |line| line =~ /nature\s*$/i }
      if nature_line.any?
        pkmn.nature = nature_line.first.sub(/\s*nature\s*$/i, "").downcase.to_sym
      end

      # All that we're left with at this point are attributes that are denoted with
      # the syntax "Attribute: Value". Let's loop over them and parse the attribute
      paragraph.each do |line|
        attribute, value = line.split /\s*:\s*/, 2
        attribute = attribute.downcase.gsub(/\s+/, "_").to_sym

        # At this point attribute will be a symbol with the snake_case approximation
        # of whatever was before the first ":" in the string. If we know what it does,
        # we can manipulate it as desired, otherwise just let it through as a string.
        # This is intended to be a flexible format.
        if %i[evs ivs].include?(attribute)
          data = value.split /\s*\/\s*/
          data.map { |d| d.split /\s+/, 2 }.each do |value, stat|
            current_value = pkmn.send attribute
            current_value[stat.downcase.to_sym] = value.to_i
            pkmn.send "#{attribute}=", current_value
          end
        elsif %i[level happiness].include?(attribute)
          pkmn.send "#{attribute}=", value.to_i
        elsif attribute == :shiny
          pkmn.shiny = %w[yes true].include?(value.downcase)
        else
          pkmn.send "#{attribute}=", value
        end
      end

      team << pkmn
    end

    team
  end

  def self.fetch(str)
  end
end
