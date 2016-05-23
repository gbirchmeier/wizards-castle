module TheWizardsCastle
class Castle

  attr_reader :rooms, :runestaff_monster

  MONSTERS = [:kobold, :orc, :wolf, :goblin, :ogre, :troll, :bear, :minotaur, :gargoyle, :chimera, :balrog, :dragon]

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
    @runestaff_monster = MONSTERS[Random.rand(MONSTERS.length)]

    set_in_random_room(:orb_of_zot)
  end


  def self.room_index(row,col,floor)
    # Equivalent to FND from BASIC, except -1 because @rooms is indexing from 0.
    raise "value out of range: (#{row},#{col},#{floor})" if [row,col,floor].any?{|n| n<1 || n>8}
    64*(floor-1)+8*(row-1)+col-1
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


  def room(row,col,floor)
    lethargy      = [row,col,floor]==@curse_location_lethargy
    leech         = [row,col,floor]==@curse_location_leech
    forgetfulness = [row,col,floor]==@curse_location_forgetfulness
    RoomContent.new(@rooms[Castle.room_index(row,col,floor)],lethargy,leech,forgetfulness)
  end

  def set_in_room(row,col,floor,symbol)
    @rooms[Castle.room_index(row,col,floor)] = RoomContent.to_intcode(symbol)
  end

  def set_in_random_room(symbol,floor=nil)
    10000.times do
      row = Random.rand(8)+1
      col = Random.rand(8)+1
      floor ||= Random.rand(8)+1
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
          loc_runestaff  = [row,col,floor] if rc.symbol==:runestaff_and_monster
          loc_orb_of_zot = [row,col,floor] if rc.symbol==:orb_of_zot
        end
      end
    end

    lines << "==="
    lines << "Curses: Lethargy=#{@curse_location_lethargy.join(',')}"
    lines.last << " Leech=#{@curse_location_leech.join(',')}"
    lines.last << " Forget=#{@curse_location_forgetfulness.join(',')}"

    lines << "Runestaff:  #{loc_runestaff.join(',')} (#{@runestaff_monster})"
    lines << "Orb of Zot: #{loc_orb_of_zot.join(',')}"

    lines
  end

end
end
