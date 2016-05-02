module TheWizardsCastle
class RoomContent

  INT_TO_SYMBOL_MAP = {
     0 => :unset, # 0 wasn't used in the original BASIC version
     1 => :empty_room,
     2 => :entrance,
     3 => :stairs_up,
     4 => :stairs_down,
     5 => :magic_pool,
     6 => :chest,
     7 => :gold,
     8 => :flares,
     9 => :warp,
    10 => :sinkhole,
    11 => :crystal_orb,
    12 => :book,
                       # monsters
    13 => :kobold,
    14 => :orc,
    15 => :wolf,
    16 => :goblin,
    17 => :ogre,
    18 => :troll,
    19 => :bear,
    20 => :minotaur,
    21 => :gargoyle,
    22 => :chimera,
    23 => :balrog,
    24 => :dragon,
    25 => :vendor,       #not a monster
                       #treasures
    26 => :ruby_red,                #cure lethargy
    27 => :norn_stone,
    28 => :pale_pearl,              #cure leech
    29 => :opal_eye,                #cure blindness
    30 => :green_gem,               #cure forgetfulness
    31 => :blue_flame,              #dissolves books
    32 => :palantir,
    33 => :silmaril,

    # the following were not implemented like this in BASIC, but it'll be better this way
    34 => :orb_of_zot,
    35 => :runestaff_and_monster
  }

  ROOM_DISPLAY_CHARACTERS = '?.EUDPCGFWSOBMMMMMMMMMMMMVTTTTTTTTWM'
                           # 0123456789 123456789 123456789 12345'

  @@symbol_to_intcode_map = INT_TO_SYMBOL_MAP.map{|k,v| [v,k]}.to_h


  def self.valid_intcode?(intcode)
    INT_TO_SYMBOL_MAP.has_key?(intcode)
  end

  def self.valid_symbol?(symbol)
    @@symbol_to_intcode_map.has_key?(symbol)
  end

  def self.to_symbol(intcode)
    INT_TO_SYMBOL_MAP[intcode] or raise "Unrecognized intcode"
  end

  def self.to_intcode(symbol)
    @@symbol_to_intcode_map[symbol] or raise "Unrecognized symbol"
  end



  attr_reader :intcode

  def initialize(intcode)
    raise "Unrecognized intcode" unless RoomContent.valid_intcode?(intcode)
    @intcode = intcode
  end

  def symbol
    RoomContent.to_symbol(@intcode)
  end

  def display
    ROOM_DISPLAY_CHARACTERS[@intcode]
  end

end
end
