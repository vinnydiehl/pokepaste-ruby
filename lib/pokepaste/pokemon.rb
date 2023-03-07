module PokePaste
  class Pokemon
    attr_accessor *%i[species nickname gender item evs ivs shiny
                      ability tera_type level happiness nature moves]

    @gender_abbrs = {m: :male, f: :female}
    class << self
      attr_accessor :gender_abbrs
    end

    def initialize(**attrs)
      unless attrs[:species]
        raise ArgumentError, "species required to initialize a PokePaste::Pokemon"
      end

      # Check types for things expected to be other than strings... everything else will
      # at worst get coverted with #to_s and so will be allowed. It is not the job of
      # this library to enforce legality, only to parse the PokéPaste format
      [[:evs, Hash],
       [:ivs, Hash],
       [:level, Integer],
       [:happiness, Integer],
       [:moves, Array]].each do |attr, type|
        unless attrs[attr].nil? || attrs[attr].is_a?(type)
          raise TypeError, "expected type #{type} for :#{attr}, received #{attrs[attr].class}"
        end
      end

      unless attrs[:shiny].nil? || [true, false].include?(attrs[:shiny])
        raise TypeError, "expected (true|false|nil) for :shiny, received #{attrs[:shiny]}"
      end

      # Process and set defaults for EVs and IVs
      %i[evs ivs].each do |attr|
        # Pluck the relevant value out of the attrs Hash if there is one
        input_attr = attrs.delete(attr) || {}

        # Error if this isn't a Hash
        unless input_attr.is_a?(Hash)
          raise ArgumentError, "expected a Hash for :#{attr}, received #{input_attr.class}"
        end

        stats = %i[hp atk def spa spd spe]

        # Error if an invalid stat is specified
        input_attr.each do |key, value|
          unless stats.include?(key)
            raise ArgumentError, "invalid :#{attr} key :#{key}, expected one of #{stats.keys}"
          end
        end

        # Set default for any stat that hasn't been specified
        stats.each do |stat|
          input_attr[stat] ||= attr == :evs ? 0 : 31
        end

        send "#{attr}=", input_attr
      end

      # Copy the attributes from the constructor to instance variables
      attrs.each { |key, value| send "#{key}=", value }

      # Both first letter and full word, string and symbol are supported for gender
      if attrs[:gender]
        gender = attrs[:gender].downcase.to_sym
        if self.class.gender_abbrs.flatten.include?(gender)
          # Either it's the key, or the value; this will find the value either way
          @gender = self.class.gender_abbrs[gender] || gender
        else
          raise TypeError,
            "expected nil or one of #{self.class.gender_abbrs.flatten} for :gender, received #{attrs[:gender]}"
        end
      end

      if attrs[:nature]
        begin
          @nature = attrs[:nature].is_a?(Integer) ? attrs[:nature] : attrs[:nature].downcase.to_sym
        rescue NoMethodError
          raise TypeError,
            "expected a (String|Symbol|Integer) for :nature, received #{attrs[:nature].class}"
        end
      end

      @shiny ||= false
      @level ||= 50
      @happiness ||= 255
      @nature ||= :hardy
      @moves ||= []
    end

    def to_s
      # Build first line
      str = @nickname ? "#{@nickname} (#{@species})" : @species.dup
      str << " (#{@gender.to_s[0].upcase})" if @gender
      str << " @ #{@item}" if @item

      str << "\nAbility: #{@ability}" if @ability
      str << "\nLevel: #{@level}" if @level != 50
      str << "\nShiny: Yes" if @shiny
      str << "\nTera Type: #{@tera_type.to_s.capitalize}" if @tera_type
      str << "\nEVs: #{stat_string @evs, 0}" if @evs.any? { |_, value| value != 0 }
      # Don't print neutral natures
      unless %i[hardy docile serious bashful quirky].include? @nature
        str << "\n#{@nature.to_s.capitalize} Nature"
      end
      str << "\nIVs: #{stat_string @ivs, 31}" if @ivs.any? { |_, value| value != 31 }
      str << "\nHappiness: #{@happiness}" if @happiness != 255

      @moves.each do |move|
        str << "\n- #{move.is_a?(Array) ? move.join(" / ") : move}"
      end

      str
    end

    def shiny?
      @shiny
    end

    private

    @@stat_inflections = {
      hp: "HP",
      atk: "Atk",
      def: "Def",
      spa: "SpA",
      spd: "SpD",
      spe: "Spe"
    }

    def stat_string(stats, default)
      stats.select { |_, value| value != default}
              .map { |stat, value| "#{value} #{@@stat_inflections[stat]}" }.join(' / ')
    end
  end
end
