module TheWizardsCastle
class RoomContent

  ROOM_THINGS = {
    unset:       { intcode: 0, mapchar: '?' },
    empty_room:  { intcode: 1, mapchar: '.' },
    entrance:    { intcode: 2, mapchar: 'E' },
    stairs_up:   { intcode: 3, mapchar: 'U' },
    stairs_down: { intcode: 4, mapchar: 'D' },
    magic_pool:  { intcode: 5, mapchar: 'P' },
    chest:       { intcode: 6, mapchar: 'C' },
    gold:        { intcode: 7, mapchar: 'G' },
    flares:      { intcode: 8, mapchar: 'F' },
    warp:        { intcode: 9, mapchar: 'W' },
    sinkhole:    { intcode: 10, mapchar: 'S' },
    crystal_orb: { intcode: 11, mapchar: 'O' },
    book:        { intcode: 12, mapchar: 'B' },

    kobold:      { intcode: 13, mapchar: 'M' },
    orc:         { intcode: 14, mapchar: 'M' },
    wolf:        { intcode: 15, mapchar: 'M' },
    goblin:      { intcode: 16, mapchar: 'M' },
    ogre:        { intcode: 17, mapchar: 'M' },
    troll:       { intcode: 18, mapchar: 'M' },
    bear:        { intcode: 19, mapchar: 'M' },
    minotaur:    { intcode: 20, mapchar: 'M' },
    gargoyle:    { intcode: 21, mapchar: 'M' },
    chimera:     { intcode: 22, mapchar: 'M' },
    balrog:      { intcode: 23, mapchar: 'M' },
    dragon:      { intcode: 24, mapchar: 'M' },

    vendor:      { intcode: 25, mapchar: 'V' },

    ruby_red:    { intcode: 26, mapchar: 'T' },  #lethargy
    norn_stone:  { intcode: 27, mapchar: 'T' },
    pale_pearl:  { intcode: 28, mapchar: 'T' },  #leech
    opal_eye:    { intcode: 29, mapchar: 'T' },  #blindness
    green_gem:   { intcode: 30, mapchar: 'T' },  #forgetfulness
    blue_flame:  { intcode: 31, mapchar: 'T' },  #dissolves books
    palantir:    { intcode: 32, mapchar: 'T' },
    silmaril:    { intcode: 33, mapchar: 'T' },

    # these two are divergences from the original BASIC impl
    orb_of_zot:  { intcode: 34, mapchar: 'W' },
    runestaff_and_monster: { intcode: 35, mapchar: 'M' }
  }

  @@intcode_to_symbol_map = ROOM_THINGS.map{|k,h| [h[:intcode],k]}.to_h


  def self.valid_intcode?(intcode)
    @@intcode_to_symbol_map.has_key?(intcode)
  end

  def self.valid_symbol?(symbol)
    ROOM_THINGS.has_key?(symbol)
  end

  def self.to_symbol(intcode)
    @@intcode_to_symbol_map[intcode] or raise "Unrecognized intcode '#{intcode}'"
  end

  def self.to_intcode(symbol)
    raise "Unrecognized symbol '#{symbol.inspect}'" unless ROOM_THINGS.has_key?(symbol)
    ROOM_THINGS[symbol][:intcode]
  end



  attr_reader :symbol

  def initialize(intcode,curse_lethargy=false,curse_leech=false,curse_forget=false)
    raise "Unrecognized intcode #{intcode}" unless RoomContent.valid_intcode?(intcode)
    @symbol = RoomContent.to_symbol(intcode)
    @cursed_with_lethargy = curse_lethargy
    @cursed_with_leech = curse_leech
    @cursed_with_forgetfulness = curse_forget
  end

  def display
    ROOM_THINGS[@symbol][:mapchar]
  end

  def cursed_with_lethargy?
    @cursed_with_lethargy
  end

  def cursed_with_leech?
    @cursed_with_leech
  end

  def cursed_with_forgetfulness?
    @cursed_with_forgetfulness
  end

end
end
