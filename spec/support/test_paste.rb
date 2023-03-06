# These aren't intended to be realistic or legal setups; this is merely to
# broadly test the features of the parser.

TEST_PASTE = <<~EOS
  Mr. Mime-Galar (M) @ Heavy-Duty Boots
  Ability: Vital Spirit
  Modest Nature
  IVs: 0 Atk / 0 Spe
  - Hidden Power [Dark]
  - Freeze-Dry
  - Dragon Hammer
  - Acid

  Armarouge

  Manny (Great Tusk)
  Ability: Protosynthesis
  Level: 85
  Shiny: Yes
  Tera Type: Ground
  EVs: 1 HP / 2 Atk / 3 Def / 4 SpA / 5 SpD / 6 Spe
  Jolly Nature
  IVs: 1 HP / 2 Atk / 3 Def / 4 SpA / 5 SpD / 6 Spe
  Happiness: 100
  - Headlong Rush
  - Earthquake

  Wo-Chien @ Rocky Helmet
  Ability: Tablets of Ruin
  Tera Type: Dark
  - Ruination
  - Zen Headbutt

  Glimmora (F)
  Shiny: Yes
  EVs: 4 Atk / 252 SpA / 252 Spe
  Naive Nature
  IVs: 0 Atk
  - Dazzling Gleam
  - Flash Cannon
  - Mortal Spin
  - Power Gem / Protect
EOS

# Identical to TEST_PASTE, uploaded to pokepast.es:
TEST_PASTE_URL = "https://pokepast.es/3f8fd09233183a98"
TEST_PASTE_ID = "3f8fd09233183a98"

# This paste is expected to be parsed into this data:
TEST_DATA = [
  {
    species: "Mr. Mime-Galar",
    nickname: nil,
    gender: :male,
    item: "Heavy-Duty Boots",
    evs: {hp: 0, atk: 0, def: 0, spa: 0, spd: 0, spe: 0},
    ivs: {hp: 31, atk: 0, def: 31, spa: 31, spd: 31, spe: 0},
    shiny: false,
    ability: "Vital Spirit",
    tera_type: nil,
    level: 50,
    happiness: 255,
    nature: :modest,
    moves: ["Hidden Power [Dark]", "Freeze-Dry", "Dragon Hammer", "Acid"]
  },
  {
    species: "Armarouge",
    nickname: nil,
    gender: nil,
    item: nil,
    evs: {hp: 0, atk: 0, def: 0, spa: 0, spd: 0, spe: 0},
    ivs: {hp: 31, atk: 31, def: 31, spa: 31, spd: 31, spe: 31},
    shiny: false,
    ability: nil,
    tera_type: nil,
    level: 50,
    happiness: 255,
    nature: :hardy,
    moves: []
  },
  {
    species: "Great Tusk",
    nickname: "Manny",
    gender: nil,
    item: nil,
    evs: {hp: 1, atk: 2, def: 3, spa: 4, spd: 5, spe: 6},
    ivs: {hp: 1, atk: 2, def: 3, spa: 4, spd: 5, spe: 6},
    shiny: true,
    ability: "Protosynthesis",
    tera_type: "Ground",
    level: 85,
    happiness: 100,
    nature: :jolly,
    moves: ["Headlong Rush", "Earthquake"]
  },
  {
    species: "Wo-Chien",
    nickname: nil,
    gender: nil,
    item: "Rocky Helmet",
    evs: {hp: 0, atk: 0, def: 0, spa: 0, spd: 0, spe: 0},
    ivs: {hp: 31, atk: 31, def: 31, spa: 31, spd: 31, spe: 31},
    shiny: false,
    ability: "Tablets of Ruin",
    tera_type: "Dark",
    level: 50,
    happiness: 255,
    nature: :hardy,
    moves: ["Ruination", "Zen Headbutt"]
  },
  {
    species: "Glimmora",
    nickname: nil,
    gender: :female,
    item: nil,
    evs: {hp: 0, atk: 4, def: 0, spa: 252, spd: 0, spe: 252},
    ivs: {hp: 31, atk: 0, def: 31, spa: 31, spd: 31, spe: 31},
    shiny: true,
    ability: nil,
    tera_type: nil,
    level: 50,
    happiness: 255,
    nature: :naive,
    moves: ["Dazzling Gleam", "Flash Cannon", "Mortal Spin", ["Power Gem", "Protect"]]
  }
]
