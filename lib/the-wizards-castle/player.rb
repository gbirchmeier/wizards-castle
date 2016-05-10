module TheWizardsCastle
class Player

  RACES = [:elf,:dwarf,:human,:hobbit]
  GENDERS = [:male,:female]

  attr_reader :race, :gender, :location

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

end
end
