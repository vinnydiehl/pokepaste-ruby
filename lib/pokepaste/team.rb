require "forwardable"

module PokePaste
  class Team
    include Enumerable
    extend Forwardable
    def_delegators :@team, *%i[size length [] empty? last index]

    def initialize
      @team = []
    end

    def each(&block)
      @team.each &block
    end

    def to_s
      map(&:to_s).join("\n\n")
    end

    def <<(pkmn)
      if pkmn.is_a? PokePaste::Pokemon
        @team << pkmn
      else
        raise TypeError, "invalid type, PokePaste::Pokemon expected"
      end
    end
  end
end
