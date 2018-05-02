module WizardsCastle

  # Represents the player state
  class Player

    RACES = %i[elf dwarf human hobbit].freeze
    GENDERS = %i[male female].freeze
    ARMORS = %i[nothing leather chainmail plate].freeze
    WEAPONS = %i[nothing dagger mace sword].freeze
    TREASURES = %i[ruby_red norn_stone pale_pearl opal_eye green_gem blue_flame palantir silmaril].freeze

    attr_reader :race, :gender, :location, :armor, :weapon, :facing,
                :armor_value, :armor_health, :weapon_value, :last_ate_turn

    def lamp?
      @has_lamp
    end

    def lamp=(bool)
      check_bool(bool)
      @has_lamp = bool
    end

    def vendor_rage?
      @vendor_rage
    end

    def vendor_rage=(bool)
      check_bool(bool)
      @vendor_rage = bool
    end

    def runestaff?
      @runestaff
    end

    def runestaff=(bool)
      check_bool(bool)
      @runestaff = bool
    end

    def orb_of_zot?
      @orb_of_zot
    end

    def orb_of_zot=(bool)
      check_bool(bool)
      @orb_of_zot = bool
    end

    def teleported?
      @teleported
    end

    def teleported=(bool)
      check_bool(bool)
      @teleported = bool
    end

    def initialize
      @room_memory = Array.new(8 * 8 * 8, false) #true means visited
      @race = nil
      @gender = nil
      @gp = 60
      @flares = 0
      @has_lamp = false
      @location = [1, 4, 1]
      @str = 0
      @int = 0
      @dex = 0
      @custom_attribute_points = 0
      @armor = :nothing
      @armor_value = 0
      @armor_health = 0
      @weapon = :nothing
      @weapon_value = 0
      @treasures = []
      @runestaff = false
      @orb_of_zot = false
      @vendor_rage = false
      @turns = 1
      @last_ate_turn = 0
      @facing = :n # needed by orb-of-zot shunt
      @teleported = false # so orb-of-zot room knows how you entered it

      # afflictions
      @blind = false
      @stickybook = false
      @forgetful = false
      @leech = false
      @lethargic = false
    end

    def dead?
      @str < 1 || @int < 1 || @dex < 1
    end

    def set_location(row, col, floor)
      if row < 1 || row > 8 || col < 1 || col > 8 || floor < 1 || floor > 8
        raise "Illegal location [#{row},#{col},#{floor}]"
      end
      @location = [row, col, floor]
    end

    def facing=(dir)
      raise "Illegal direction '#{dir.inspect}'" unless [:n, :s, :w, :e].include?(dir)
      @facing = dir
    end


    def race=(race)
      raise "Unrecognized race parameter '#{race.inspect}'" unless RACES.include?(race)
      @race = race
    end

    def gender=(gen)
      #maybe in a future version I'll allow non-binary genders
      raise 'Unrecognized gender parameter' unless GENDERS.include?(gen)
      @gender = gen
    end

    def armor=(armor)
      raise 'Unrecognized armor parameter' unless ARMORS.include?(armor)
      @armor = armor
      @armor_value = ARMORS.index(armor)
      @armor_health = @armor_value * 7
    end

    def weapon=(weap)
      raise 'Unrecognized weapon parameter' unless WEAPONS.include?(weap)
      @weapon = weap
      @weapon_value = WEAPONS.index(weap)
    end

    def flares(increment = 0)
      @flares += increment.to_i
      @flares = 0 if @flares < 0
      @flares
    end

    def gp(increment = 0)
      @gp += increment.to_i
      @gp = 0 if @gp < 0
      @gp
    end

    def str(increment = 0)
      @str += increment.to_i
      @str = 0 if @str < 0
      @str = 18 if @str > 18
      @str
    end

    def int(increment = 0)
      @int += increment.to_i
      @int = 0 if @int < 0
      @int = 18 if @int > 18
      @int
    end

    def dex(increment = 0)
      @dex += increment.to_i
      @dex = 0 if @dex < 0
      @dex = 18 if @dex > 18
      @dex
    end

    def turns(increment = 0)
      @turns += increment.to_i
    end

    def custom_attribute_points(increment = 0)
      @custom_attribute_points += increment
    end

    def treasure_count
      @treasures.length
    end

    def add_treasure(treasure)
      raise "invalid treasure #{treasure.inspect}" unless TREASURES.include?(treasure)
      raise "already have treasure #{treasure.inspect}" if @treasures.include?(treasure)
      @treasures << treasure
    end

    def remove_treasure(treasure)
      raise "invalid treasure #{treasure.inspect}" unless TREASURES.include?(treasure)
      raise "don't have treasure #{treasure.inspect}" unless @treasures.include?(treasure)
      @treasures.delete(treasure)
    end

    def have_treasure?(treasure)
      raise "invalid treasure #{treasure.inspect}" unless TREASURES.include?(treasure)
      @treasures.include?(treasure)
    end

    def random_treasure
      return nil if treasure_count < 1
      @treasures.sample
    end

    def knows_room?(col, row, floor)
      @room_memory[Castle.room_index(col, row, floor)]
    end

    def remember_room(col, row, floor)
      @room_memory[Castle.room_index(col, row, floor)] = true
    end

    def forget_random_room
      loc = Castle.random_room
      idx = Castle.room_index(*loc)
      @room_memory[idx] = false
    end

    def update_last_ate_turn!
      @last_ate_turn = @turns
    end


    # afflictions
    def blind?
      @blind
    end

    def set_blind(bool)
      check_bool(bool)
      @blind = bool
    end

    def stickybook?
      @stickybook
    end

    def set_stickybook(bool)
      check_bool(bool)
      @stickybook = bool
    end

    def forgetful?
      @forgetful
    end

    def set_forgetful(bool)
      check_bool(bool)
      @forgetful = bool
    end

    def leech?
      @leech
    end

    def set_leech(bool)
      check_bool(bool)
      @leech = bool
    end

    def lethargic?
      @lethargic
    end

    def set_lethargic(bool)
      check_bool(bool)
      @lethargic = bool
    end


    # combat
    def take_a_hit!(damage, printer = nil)
      if @armor == :nothing
        str(-damage)
      else
        if damage >= @armor_value
          loss = damage - @armor_value
          str(-loss)
          @armor_health -= @armor_value
        else
          @armor_health -= damage
        end

        if @armor_health <= 0
          self.armor = :nothing
          printer.armor_destroyed if printer
        end
      end
      nil
    end


    private

    def check_bool(bool)
      raise "Parameter is not a boolean: #{bool.inspect}" unless [true, false].include?(bool)
    end

  end
end
