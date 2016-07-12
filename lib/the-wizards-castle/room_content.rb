module TheWizardsCastle
class RoomContent

  ROOM_THINGS = {
    unset:       { intcode: 0, mapchar: '?', text: "<ERROR>" },
    empty_room:  { intcode: 1, mapchar: '.', text: "AN EMPTY ROOM" },
    entrance:    { intcode: 2, mapchar: 'E', text: "THE ENTRANCE" },
    stairs_up:   { intcode: 3, mapchar: 'U', text: "STAIRS GOING UP" },
    stairs_down: { intcode: 4, mapchar: 'D', text: "STAIRS GOING DOWN" },
    magic_pool:  { intcode: 5, mapchar: 'P', text: "A POOL" },
    chest:       { intcode: 6, mapchar: 'C', text: "A CHEST" },
    gold:        { intcode: 7, mapchar: 'G', text: "GOLD PIECES" },
    flares:      { intcode: 8, mapchar: 'F', text: "FLARES" },
    warp:        { intcode: 9, mapchar: 'W', text: "A WARP" },
    sinkhole:    { intcode: 10, mapchar: 'S', text: "A SINKHOLE" },
    crystal_orb: { intcode: 11, mapchar: 'O', text: "A CRYSTAL ORB" },
    book:        { intcode: 12, mapchar: 'B', text: "A BOOK" },

    kobold:      { intcode: 13, mapchar: 'M', text: "A KOBOLD" },
    orc:         { intcode: 14, mapchar: 'M', text: "AN ORC" },
    wolf:        { intcode: 15, mapchar: 'M', text: "A WOLF" },
    goblin:      { intcode: 16, mapchar: 'M', text: "A GOBLIN" },
    ogre:        { intcode: 17, mapchar: 'M', text: "AN OGRE" },
    troll:       { intcode: 18, mapchar: 'M', text: "A TROLL" },
    bear:        { intcode: 19, mapchar: 'M', text: "A BEAR" },
    minotaur:    { intcode: 20, mapchar: 'M', text: "A MINOTAUR" },
    gargoyle:    { intcode: 21, mapchar: 'M', text: "A GARGOYLE" },
    chimera:     { intcode: 22, mapchar: 'M', text: "A CHIMERA" },
    balrog:      { intcode: 23, mapchar: 'M', text: "A BALROG" },
    dragon:      { intcode: 24, mapchar: 'M', text: "A DRAGON" },

    vendor:      { intcode: 25, mapchar: 'V', text: "A VENDOR" },

    ruby_red:    { intcode: 26, mapchar: 'T', text: "THE RUBY RED" },    #lethargy
    norn_stone:  { intcode: 27, mapchar: 'T', text: "THE NORN STONE" },
    pale_pearl:  { intcode: 28, mapchar: 'T', text: "THE PALE PEARL" },  #leech
    opal_eye:    { intcode: 29, mapchar: 'T', text: "THE OPAL EYE" },    #blindness
    green_gem:   { intcode: 30, mapchar: 'T', text: "THE GREEN GEM" },   #forgetfulness
    blue_flame:  { intcode: 31, mapchar: 'T', text: "THE BLUE FLAME" },  #dissolves books
    palantir:    { intcode: 32, mapchar: 'T', text: "THE PALANTIR" },
    silmaril:    { intcode: 33, mapchar: 'T', text: "THE SILMARIL" },

    # these two are divergences from the original BASIC impl
    orb_of_zot:  { intcode: 34, mapchar: 'W', text: "A WARP" },
    runestaff_and_monster: { intcode: 35, mapchar: 'M', text: "<ERROR-NO-MONSTER>" }
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

  def initialize(intcode,curse_lethargy=false,curse_leech=false,curse_forget=false,monster_type=nil)
    raise "Unrecognized intcode #{intcode}" unless RoomContent.valid_intcode?(intcode)
    @symbol = RoomContent.to_symbol(intcode)
    raise "Param monster_type is only valid on the runestaff room" if (@symbol==:runestaff_and_monster && monster_type)
    @cursed_with_lethargy = curse_lethargy
    @cursed_with_leech = curse_leech
    @cursed_with_forgetfulness = curse_forget
    @monster_type = monster_type
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

  def text
    sym = (@symbol==:runestaff_and_monster && @monster_type) ? @monster_type : @symbol
    ROOM_THINGS[@symbol][:text].dup
  end

  def monster?
    ROOM_THINGS[@symbol][:mapchar]=='M'
  end

  def treasure?
    ROOM_THINGS[@symbol][:mapchar]=='T'
  end

  def monster_symbol
    raise "no monster in room (has #{symbol.to_s})" unless (self.monster? || @symbol==:vendor)
    (@symbol==:runestaff_and_monster && @monster_type) ? @monster_type : @symbol
  end

end
end
