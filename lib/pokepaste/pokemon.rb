module PokePaste
  class Pokemon
    attr_accessor *%i[species nickname gender item evs ivs shiny
                      ability tera_type level happiness nature moves]

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
      genders = {m: :male, f: :female}
      if attrs[:gender]
        gender = attrs[:gender].downcase.to_sym
        if genders.flatten.include?(gender)
          # Either it's the key, or the value; this will find the value either way
          @gender = genders[gender] || gender
        else
          raise TypeError,
            "expected nil or one of #{genders.flatten} for :gender, received #{attrs[:gender]}"
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
    end

    def shiny?
      @shiny
    end
  end
end
