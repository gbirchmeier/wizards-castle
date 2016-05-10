module TheWizardsCastle
class Player

  RACES = [:elf,:dwarf,:human,:hobbit]
  GENDERS = [:male,:female]
  ARMORS = [:plate,:chainmail,:leather,:nothing]
  WEAPONS = [:sword,:mace,:dagger,:nothing]
  TREASURES = [:ruby_red,:norn_stone,:pale_pearl,:opal_eye,:green_gem,:blue_flame,:palantir,:silmaril]

  attr_reader :race, :gender, :location, :armor, :weapon

  def lamp?
    return @has_lamp
  end


  def initialize
    @race = nil
    @gender = nil
    @gp = 60
    @flares = 0
    @has_lamp = false
    @location = [1,4,1]
    @str = 0
    @int = 0
    @dex = 0
    @armor = nil
    @weapon = nil
    @treasures = []
  end

  def set_race r
    raise "Unrecognized race parameter '#{r.inspect}'" unless RACES.include?(r)
    @race = r
  end

  def set_gender g
    #maybe in a future version I'll allow user to change it
    raise "Unrecognized gender parameter" unless GENDERS.include?(g)
    @gender = g
  end

  def set_lamp bool
    raise "Parameter is not a boolean: #{bool.inspect}" unless [true,false].include?(bool)
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

  def flares n=0
    @flares += n.to_i
  end

  def gp n=0
    @gp += n.to_i
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

end
end
