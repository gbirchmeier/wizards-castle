module TheWizardsCastle
class Player

  RACES = [:elf,:dwarf,:human,:hobbit]
  GENDERS = [:male,:female]
  ARMORS = [:plate,:chainmail,:leather,:nothing]
  WEAPONS = [:sword,:mace,:dagger,:nothing]
  TREASURES = [:ruby_red,:norn_stone,:pale_pearl,:opal_eye,:green_gem,:blue_flame,:palantir,:silmaril]

  attr_reader :race, :gender, :location, :armor, :weapon

  def lamp?
    @has_lamp
  end

  def vendor_rage?
    @vendor_rage
  end

  def initialize
    @room_memory = Array.new(8*8*8,false) #true means visited
    @race = nil
    @gender = nil
    @gp = 60
    @flares = 0
    @has_lamp = false
    @location = [1,4,1]
    @str = 0
    @int = 0
    @dex = 0
    @custom_attribute_points = 0
    @armor = nil
    @weapon = nil
    @treasures = []
    @vendor_rage = false

    @blind = false
  end

  def set_location(row,col,floor)
    if row<1 || row>8 || col<1 || col>8 || floor<1 || floor>8
      raise "Illegal location [#{row},#{col},#{floor}]"
    end
    @location = [row,col,floor]
  end

  def set_race r
    raise "Unrecognized race parameter '#{r.inspect}'" unless RACES.include?(r)
    @race = r
  end

  def set_gender g
    #maybe in a future version I'll allow non-binary genders
    raise "Unrecognized gender parameter" unless GENDERS.include?(g)
    @gender = g
  end

  def set_lamp bool
    check_bool(bool)
    @has_lamp = bool
  end

  def set_armor a
    raise "Unrecognized armor parameter" unless ARMORS.include?(a)
    @armor = a
  end

  def set_weapon w
    raise "Unrecognized weapon parameter" unless WEAPONS.include?(w)
    @weapon = w
  end

  def vendor_rage?
    @vendor_rage
  end

  def set_vendor_rage bool
    check_bool(bool)
    @vendor_rage = bool
  end

  def flares n=0
    @flares += n.to_i
  end

  def gp n=0
    @gp += n.to_i
    @gp=0 if @gp<0
    @gp
  end

  def str n=0
    @str += n.to_i
  end

  def int n=0
    @int += n.to_i
  end

  def dex n=0
    @dex += n.to_i
  end

  def custom_attribute_points n=0
    @custom_attribute_points += n
  end

  def treasure_count
    @treasures.length
  end

  def add_treasure(t)
    raise "invalid treasure #{t.inspect}" unless TREASURES.include?(t)
    raise "already have treasure #{t.inspect}" if @treasures.include?(t)
    @treasures << t
  end

  def remove_treasure(t)
    raise "don't have treasure #{t.inspect}" unless @treasures.include(t)
    @treasure.delete(t)
  end

  def have_treasure?(t)
    raise "invalid treasure #{t.inspect}" unless TREASURES.include?(t)
    @treasures.include?(t)
  end

  def knows_room?(col,row,floor)
    @room_memory[Castle.room_index(col,row,floor)]
  end

  def remember_room(col,row,floor)
    @room_memory[Castle.room_index(col,row,floor)] = true
  end

  def forget_random_room
    loc = Castle.random_room
    idx = Castle.room_index(*loc)
    @room_memory[idx] = false
  end

  def blind?
    @blind
  end

  def set_blind(bool)
    check_bool(bool)
  end

private
  def check_bool(bool)
    raise "Parameter is not a boolean: #{bool.inspect}" unless [true,false].include?(bool)
  end

end
end
