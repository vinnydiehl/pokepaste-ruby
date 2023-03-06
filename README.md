# PokéPaste Ruby

Ruby parser for [PokéPaste](https://pokepast.es/syntax.html), the format used
by Pokémon Showdown and various teambuilders.

## Under Construction!

The outline given below is the intended behavior of the library for version
0.1. Tests for this behavior are implemented in
[`spec/`](https://github.com/vinnydiehl/pokepaste-ruby/tree/develop/spec); if
you have stumbled upon this library already and are interested in helping, run
the tests to see where we're at.

## Installation

Install with [RubyGems](https://rubygems.org/gems/pokepaste):

```bash
gem install pokepaste
```

If using in your application, include in your `Gemfile`:

```ruby
gem "pokepaste"
```

or your `.gemspec`:

```ruby
Gem::Specification.new do |gem|
  # ...

  gem.add_runtime_dependency "pokepaste"
end
```

## Usage

To parse a PokéPaste:

```ruby
# From a string
team = PokePaste::parse(str)

# From pokepast.es
team = PokePaste::fetch("https://pokepast.es/5c46f9ec443664cb")
team = PokePaste::fetch("5c46f9ec443664cb") # full URL optional
```

These methods return an instance of `PokePaste::Team`, an Enumerable
containing an instance of `PokePaste::Pokemon` for each Pokémon on
the team. You can loop over the team as with any Enumerable, and access the
data like so:

```ruby
team.each do |pkmn|
  pkmn.species # required
  pkmn.nickname # default nil
  pkmn.gender # default nil
  pkmn.item # default nil

  # EVs and IVs are hashes with the stat as the key
  # (:hp, :atk, :def, :spa, :spd, or :spe)
  pkmn.evs[:hp] # default 0
  pkmn.ivs[:spa] # default 31

  pkmn.shiny? # default is false
  pkmn.ability # default is nil
  pkmn.tera_type # default is nil
  pkmn.level # default is 50
  pkmn.happiness # default is 255
  pkmn.nature # default is :hardy (neutral nature)

  # Moves are an array with the names of the moves as strings. If more than
  # one move is specified for a slot, they will be put into an array
  pkmn.moves # default is []
end
```

You can edit any of these properties, and process back into PokéPaste format
with `#to_s`:

```ruby
paste = team.to_s
single_pokemon = team[3].to_s
```

To make a new paste, you can initialize a new `PokePaste::Team` and populate
it like so:

```ruby
team = PokePaste::Team.new

team << PokePaste::Pokemon.new(
  species: "Bulbasaur",
  nickname: "Bud",
  ivs: {atk: 0},
  shiny: true,
  moves: %w[Tackle Growl]
)

puts team # prints the paste
```

And I suppose if you wanted to use this library just to fetch the raw text from
a paste on [pokepast.es](https://pokepast.es/), you could:

```ruby
raw_paste = PokePaste.fetch(url_or_id).to_s
```

This library is purely a parser for the PokéPaste format, it does not contain
any data about the Pokémon, whether or not the moves are valid, their
abilities, anything like that. You could enter nonsense into any of the given
fields and they will be parsed to and from the PokéPaste format happily.
Validating anything beyond the syntax of the PokéPaste is left up to the user.

## License

This library is released under the MIT license. See the
[`LICENSE.md`](https://github.com/vinnydiehl/pokepaste-ruby/blob/develop/LICENSE.md)
file included with this code or
[the official page on OSI](http://opensource.org/licenses/MIT) for more information.

I am not affiliated with Nintendo, Game Freak, The Pokémon Company, or any of
their subsidiaries. This is a free fan-made project. Pokémon is © and ™ Nintendo.
