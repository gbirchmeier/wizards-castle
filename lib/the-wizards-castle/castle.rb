module TheWizardsCastle
class Castle

  attr_reader :backmap, :rooms

  def initialize
    @rooms = Array.new(8*8*8, RoomContent.to_intcode(:empty_room)) # unlike BASIC, index starts at 0

    set_in_room(4,1,1,:entrance)
    (1..7).each do |z|
      xroom = set_in_random_room(:stairs_down,z)
      xroom[2] = xroom[2]+1
      set_in_room(*xroom,:stairs_up)
    end

    monsters = [:kobold, :orc, :wolf, :goblin, :ogre, :troll, :bear, :minotaur, :gargoyle, :chimera, :balrog, :dragon]
    other_things = [:magic_pool, :chest, :gold, :flares, :warp, :sinkhole, :crystal_orb, :book, :vendor]
    (1..8).each do |z|
      monsters.each {|monster| set_in_random_room(monster,z)}
      other_things.each {|thing| 3.times { set_in_random_room(thing,z)}}
    end

    treasures = [:ruby_red, :norn_stone, :pale_pearl, :opal_eye, :green_gem, :blue_flame, :palantir, :silmaril]
    treasures.each {|treasure| set_in_random_room(treasure)}

    # I can't believe I'm using the same empty_room hack that Stetson-BASIC is using
    # Multiple curses can be in the same room, and the runestaff/orb may also be later placed into a curse room.
    # (This is just how the old game implemented it.)
    @curse_lethargy_location      = set_in_random_room(:empty_room)
    @curse_leech_location         = set_in_random_room(:empty_room)
    @curse_forgetfulness_location = set_in_random_room(:empty_room)

    set_in_random_room(:runestaff_and_monster)
    @runestaff_monster = monsters[Random.rand(monsters.length)]

    set_in_random_room(:orb_of_zot)
  end


  def self.room_index(x,y,z)
    # Equivalent to FND from BASIC, except -1 because @rooms is indexing from 0.
    # z is the level
    raise "value out of range: (#{x},#{y},#{z})" if [x,y,z].any?{|n| n<1 || n>8}
    64*(z-1)+8*(x-1)+y-1
  end

  def room(x,y,z)
    RoomContent.new(@rooms[Castle.room_index(x,y,z)])
  end

  def set_in_room(x,y,z,symbol)
    @rooms[Castle.room_index(x,y,z)] = RoomContent.to_intcode(symbol)
  end

  def set_in_random_room(symbol,z=nil)
    10000.times do
      x = Random.rand(8)+1
      y = Random.rand(8)+1
      z ||= Random.rand(8)+1
      if room(x,y,z).symbol == :empty_room
        set_in_room(x,y,z,symbol)
        return [x,y,z]
      end
    end
    raise "can't find empty room"
  end

  def debug_display
    lines = []
    loc_runestaff = nil
    loc_orb_of_zot = nil

    (1..8).each do |z|
      lines << "===LEVEL #{z}"
      (1..8).each do |y|
        lines << " "
        (1..8).each do |x|
          rc = room(x,y,z)
          lines.last << " "+rc.display
          loc_runestaff  = [x,y,z] if rc.symbol==:runestaff_and_monster
          loc_orb_of_zot = [x,y,z] if rc.symbol==:orb_of_zot
        end
      end
    end

    lines << "==="
    lines << "Curses: Lethargy=#{@curse_lethargy_location.join(',')}"
    lines.last << " Leech=#{@curse_leech_location.join(',')}"
    lines.last << " Forget=#{@curse_leech_location.join(',')}"

    lines << "Runestaff:  #{loc_runestaff.join(',')} (#{@runestaff_monster})"
    lines << "Orb of Zot: #{loc_orb_of_zot.join(',')}"

    lines
  end

end
end
