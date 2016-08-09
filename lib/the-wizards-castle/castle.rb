module TheWizardsCastle
class Castle

  attr_reader :rooms, :runestaff_monster, :orb_of_zot_location

  MONSTERS = [:kobold, :orc, :wolf, :goblin, :ogre, :troll, :bear, :minotaur, :gargoyle, :chimera, :balrog, :dragon]


  #
  # Locations: row/col/floor range from 1-8, just like what players see (i.e. indexed from 1, not 0.)
  #



  def initialize
    @rooms = Array.new(8*8*8, RoomContent.to_intcode(:empty_room)) # unlike BASIC, index starts at 0

    set_in_room(1,4,1,:entrance)
    (1..7).each do |floor|
      xroom = set_in_random_room(:stairs_down,floor)
      xroom[2] = xroom[2]+1
      set_in_room(*xroom,:stairs_up)
    end

    other_things = [:magic_pool, :chest, :gold, :flares, :warp, :sinkhole, :crystal_orb, :book, :vendor]
    (1..8).each do |floor|
      MONSTERS.each {|monster| set_in_random_room(monster,floor)}
      other_things.each {|thing| 3.times { set_in_random_room(thing,floor)}}
    end

    treasures = [:ruby_red, :norn_stone, :pale_pearl, :opal_eye, :green_gem, :blue_flame, :palantir, :silmaril]
    treasures.each {|treasure| set_in_random_room(treasure)}

    # Multiple curses can be in the same room, and the runestaff/orb
    # may also be later placed into a curse room.
    # This is just how the old game implemented it.
    # (I can't believe I'm using the same empty_room hack that Stetson-BASIC is using)
    @curse_location_lethargy      = set_in_random_room(:empty_room)
    @curse_location_leech         = set_in_random_room(:empty_room)
    @curse_location_forgetfulness = set_in_random_room(:empty_room)

    set_in_random_room(:runestaff_and_monster)
    @runestaff_monster = MONSTERS.sample

    @orb_of_zot_location = set_in_random_room(:orb_of_zot)
  end


  def self.room_index(row,col,floor)
    # Equivalent to FND from BASIC, except -1 because @rooms is indexing from 0.
    raise "value out of range: (#{row},#{col},#{floor})" if [row,col,floor].any?{|n| n<1 || n>8}
    64*(floor-1)+8*(row-1)+col-1
  end

  def self.move(dir,row,col,floor)
    case dir
    when "N" then return Castle.north(row,col,floor)
    when "S" then return Castle.south(row,col,floor)
    when "E" then return Castle.east(row,col,floor)
    when "W" then return Castle.west(row,col,floor)
    else raise "Illegal direction '#{dir}'"
    end
  end

  def self.north(row,col,floor)
    row==1 ? [8,col,floor] : [row-1,col,floor]
  end

  def self.south(row,col,floor)
    row==8 ? [1,col,floor] : [row+1,col,floor]
  end

  def self.west(row,col,floor)
    col==1 ? [row,8,floor] : [row,col-1,floor]
  end

  def self.east(row,col,floor)
    col==8 ? [row,1,floor] : [row,col+1,floor]
  end

  def self.up(row,col,floor)
    floor==1 ? [row,col,8] : [row,col,floor-1]
  end

  def self.down(row,col,floor)
    floor==8 ? [row,col,1] : [row,col,floor+1]
  end

  def self.random_room(floor=nil)
    row = Random.rand(8)+1
    col = Random.rand(8)+1
    floor ||= Random.rand(8)+1
    [row,col,floor]
  end

  def self.flare_locs(row,col,floor)
    top_row = row==1 ? 8 : row-1
    bottom_row = row==8 ? 1 : row+1
    left_col = col==1 ? 8 : col-1
    right_col = col==8 ? 1 : col+1
    rv = Array.new
    rv << [top_row,left_col,floor]      # top-left
    rv << [top_row,col,floor]           # top-middle
    rv << [top_row,right_col,floor]     # top-right
    rv << [row,left_col,floor]          # left
    rv << [row,col,floor]               # center
    rv << [row,right_col,floor]         # right
    rv << [bottom_row,left_col,floor]   # bottom-left
    rv << [bottom_row,col,floor]        # bottom-middle
    rv << [bottom_row,right_col,floor]  # bottom-right
    rv
  end

  def room(row,col,floor)
    lethargy      = [row,col,floor]==@curse_location_lethargy
    leech         = [row,col,floor]==@curse_location_leech
    forgetfulness = [row,col,floor]==@curse_location_forgetfulness
    monster_type  = [row,col,floor]==@runestaff_location ? @runestaff_monster : nil
    RoomContent.new(@rooms[Castle.room_index(row,col,floor)],lethargy,leech,forgetfulness,monster_type)
  end

  def set_in_room(row,col,floor,symbol)
    if self.room(row,col,floor).symbol==:runestaff_and_monster
      @runestaff_location = nil
    end
    if symbol==:runestaff_and_monster
      @runestaff_location = [row,col,floor]
    end
    @rooms[Castle.room_index(row,col,floor)] = RoomContent.to_intcode(symbol)
  end

  def set_in_random_room(symbol,floor=nil)
    10000.times do
      row,col,floor = Castle.random_room(floor)
      if room(row,col,floor).symbol == :empty_room
        set_in_room(row,col,floor,symbol)
        return [row,col,floor]
      end
    end
    raise "can't find empty room"
  end

  def debug_display
    lines = []
    loc_runestaff = nil
    loc_orb_of_zot = nil

    (1..8).each do |floor|
      lines << "===LEVEL #{floor}"
      (1..8).each do |row|
        lines << " "
        (1..8).each do |col|
          rc = room(row,col,floor)
          lines.last << " "+rc.display
        end
      end
    end

    lines << "==="
    lines << "Curses: Lethargy=#{@curse_location_lethargy.join(',')}"
    lines.last << " Leech=#{@curse_location_leech.join(',')}"
    lines.last << " Forget=#{@curse_location_forgetfulness.join(',')}"

    if @runestaff_location
      lines << "Runestaff:  #{runestaff_location.join(',')} (#{@runestaff_monster})"
    else
      lines << "Runestaff removed from last location"
    end
    lines << "Orb of Zot: #{orb_of_zot_location.join(',')}"

    lines
  end

end
end
