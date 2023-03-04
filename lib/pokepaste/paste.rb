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
    end
  end
end
