module WizardsCastle

  # The game runner.  Everything starts here.
  class Runner

    module PlayerState
      NEW_ROOM = :new_room
      ACTION = :action
      DIED = :died
      QUIT = :quit
      EXITED = :exited
    end

    def self.run
      n = 0
      loop do
        runner = Runner.new
        runner.setup
        runner.intro if n.zero?
        runner.character_creation
        break unless runner.play
        n += 1
      end
    end


    attr_accessor :prompter, :castle, :player, :printer


    def initialize
      @prompter = nil
      @castle = nil
      @player = nil
      @printer = nil
    end

    def intro
      @printer.intro
    end

    # TODO: move test_input support to a spec-only monkeypatch
    def setup(test_input = {})
      @prompter = test_input[:prompter] || Prompter.new
      @castle = test_input[:castle] || Castle.new
      @player = test_input[:player] || Player.new
      @printer = test_input[:printer] || StetsonPrinter.new(@player, @castle)
    end

    def character_creation
      @printer.character_creation_header
      ask_race
      ask_gender
      ask_attributes
      @printer.gold_report1
      ask_armor
      @printer.gold_report2
      ask_weapon
      ask_lamp
      return if @player.gp < 1
      @printer.gold_report3
      ask_flares
    end

    def play
      # returns true if user wants to play again

      @player.set_location(1, 4, 1) #entrance
      @printer.entering_the_castle

      status = PlayerState::NEW_ROOM
      loop do
        case status
        when PlayerState::NEW_ROOM
          status = enter_room
        when PlayerState::ACTION
          status = player_action
        end

        break if [PlayerState::QUIT, PlayerState::EXITED, PlayerState::DIED].include? status
      end

      case status
      when PlayerState::DIED
        @printer.death
      when PlayerState::QUIT
        @printer.quit
      when PlayerState::EXITED
        @printer.exit_castle
      end
      @printer.endgame_possessions

      answer = @prompter.ask(['Y', 'N'], @printer.prompt_play_again)
      if answer == 'Y'
        @printer.play_again
        @printer.restock
        return true
      end

      @printer.shut_down
      false
    end



    ##############################
    # Character creation prompts

    def ask_race
      allowed = {
        'E' => :elf,
        'D' => :dwarf,
        'M' => :human,
        'H' => :hobbit
      }
      answer = @prompter.ask(allowed.keys, @printer.prompt_race)
      @player.race = allowed[answer]

      case @player.race
      when :hobbit
        @player.str(+4)
        @player.int(+8)
        @player.dex(+12)
        @player.custom_attribute_points(+4)
      when :elf
        @player.str(+6)
        @player.int(+8)
        @player.dex(+10)
        @player.custom_attribute_points(+8)
      when :human
        @player.str(+8)
        @player.int(+8)
        @player.dex(+8)
        @player.custom_attribute_points(+8)
      when :dwarf
        @player.str(+10)
        @player.int(+8)
        @player.dex(+6)
        @player.custom_attribute_points(+8)
      end
    end

    def ask_gender
      allowed = {
        'M' => :male,
        'F' => :female
      }
      answer = @prompter.ask(allowed.keys, @printer.prompt_gender)
      @player.gender = allowed[answer]
    end


    def ask_attributes
      @printer.attributes_header
      ask_strength
      ask_intelligence
      ask_dexterity
    end

    def ask_strength
      return if @player.custom_attribute_points < 1

      max = 18 - @player.str
      max = @player.custom_attribute_points if max > @player.custom_attribute_points
      n = @prompter.ask_integer(0, max, @printer.prompt_add_to_strength)
      @player.custom_attribute_points(-n)
      @player.str(+n)
    end

    def ask_intelligence
      return if @player.custom_attribute_points < 1

      max = 18 - @player.int
      max = @player.custom_attribute_points if max > @player.custom_attribute_points
      n = @prompter.ask_integer(0, max, @printer.prompt_add_to_intelligence)
      @player.custom_attribute_points(-n)
      @player.int(+n)
    end

    def ask_dexterity
      return if @player.custom_attribute_points < 1

      max = 18 - @player.dex
      max = @player.custom_attribute_points if max > @player.custom_attribute_points
      n = @prompter.ask_integer(0, max, @printer.prompt_add_to_dexterity)
      @player.custom_attribute_points(-n)
      @player.dex(+n)
    end


    def ask_armor
      allowed = Player::ARMORS.collect{|x| [x.to_s[0].upcase, x]}.to_h
      costs = { plate: 30, chainmail: 20, leather: 10, nothing: 0 }
      answer = @prompter.ask(allowed.keys, @printer.prompt_armor)
      armor = allowed[answer]
      @player.armor = armor
      @player.gp(-1 * costs[armor])
    end

    def ask_weapon
      allowed = Player::WEAPONS.collect{|x| [x.to_s[0].upcase, x]}.to_h
      costs = { sword: 30, mace: 20, dagger: 10, nothing: 0 }
      answer = @prompter.ask(allowed.keys, @printer.prompt_weapon)
      weapon = allowed[answer]
      @player.weapon = weapon
      @player.gp(-1 * costs[weapon])
    end

    def ask_lamp
      return if @player.gp < 20

      answer = @prompter.ask(['Y', 'N'], @printer.prompt_lamp)
      return unless answer == 'Y'
      @player.lamp = true
      @player.gp(-20)
    end

    def ask_flares
      return if @player.gp < 1
      n = @prompter.ask_integer(0, @player.gp, @printer.prompt_flares)
      @player.flares(+n)
      @player.gp(-n)
    end

    # End of character creation prompts
    #####################################


    def enter_room
      # returns a Player::Status

      loc = @player.location
      rc = @castle.room(*loc)

      entered_via_teleport = @player.teleported?
      @player.teleported = false

      if @player.blind?
        @printer.you_are_here_blind
      else
        @printer.you_are_here
      end

      @printer.stat_block

      @player.remember_room(*loc) #remember even if blind

      symbol_for_text =
        if rc.symbol == :runestaff_and_monster
          @castle.runestaff_monster
        else
          rc.symbol
        end
      @printer.here_you_find(symbol_for_text)

      case rc.symbol
      when :gold
        n = Random.rand(1..10)
        @player.gp(+n)
        @printer.new_gold_count
        @castle.set_in_room(*loc, :empty_room)
        return PlayerState::ACTION
      when :flares
        n = Random.rand(1..5)
        @player.flares(+n)
        @printer.new_flare_count
        @castle.set_in_room(*loc, :empty_room)
        return PlayerState::ACTION
      when :warp
        @player.set_location(*Castle.random_room)
        return PlayerState::NEW_ROOM
      when :sinkhole
        @player.set_location(*Castle.down(*loc))
        return PlayerState::NEW_ROOM
      when :orb_of_zot
        if entered_via_teleport
          @printer.found_orb_of_zot
          @player.runestaff = false
          @player.orb_of_zot = true
          @castle.set_in_room(*loc, :empty_room)
          return PlayerState::ACTION
        else
          @player.set_location(*Castle.move(@player.facing.to_s.upcase, *loc))
          return PlayerState::NEW_ROOM
        end
      end

      if rc.treasure?
        @player.add_treasure(rc.symbol)
        @printer.got_a_treasure(rc.symbol)
        @castle.set_in_room(*loc, :empty_room)
        return PlayerState::ACTION
      elsif rc.monster?
        return combat
      elsif rc.symbol == :vendor
        return combat if @player.vendor_rage?

        case @prompter.ask(%w[T A I], @printer.prompt_vendor_encounter)
        when 'I'
          return PlayerState::ACTION
        when 'A'
          @player.vendor_rage = true
          @printer.vendor_responds_to_attack
          return combat
        when 'T'
          ShoppingTrip.new(@player, @printer, @prompter).run
          return PlayerState::ACTION
        end
      end

      PlayerState::ACTION
    end

    def leech_gp_loss
      Random.rand(1..5)
    end

    def do_random_flavor_text?
      Random.rand(5).zero? # 20% chance
    end

    def player_action
      loc = @player.location
      rc = @castle.room(*loc)

      @player.turns(+1)

      unless @player.runestaff? || @player.orb_of_zot?
        @player.turns(+1) if @player.lethargic? && !@player.have_treasure?(:ruby_red)
        @player.gp(-leech_gp_loss) if @player.leech? && !@player.have_treasure?(:pale_pearl)
        @player.forget_random_room if @player.forgetful? && !@player.have_treasure?(:green_gem)

        @player.lethargic = true if rc.cursed_with_lethargy?
        @player.leech = true if rc.cursed_with_leech?
        @player.forgetful = true if rc.cursed_with_forgetfulness?
      end


      @printer.player_action_flavor_text if do_random_flavor_text?


      if @player.blind? && @player.have_treasure?(:opal_eye)
        @printer.cure_blindness
        @player.blind = false
      end

      if @player.stickybook? && @player.have_treasure?(:blue_flame)
        @printer.cure_stickybook
        @player.stickybook = false
      end


      valid_cmds = %w[H N S E W U D DR M F L O G T Q]
      cmd = @prompter.ask(valid_cmds, @printer.prompt_standard_action)

      if %w[M F L G].include?(cmd) && @player.blind?
        @printer.blind_command_error
        return PlayerState::ACTION
      end

      case cmd
      when 'H'
        @printer.help_message
        return PlayerState::ACTION
      when 'N', 'S', 'E', 'W'
        return PlayerState::EXITED if cmd == 'N' && rc.symbol == :entrance
        @player.set_location(*Castle.move(cmd, *loc))
        @player.facing = cmd.downcase.to_sym
        return PlayerState::NEW_ROOM
      when 'U'
        if rc.symbol == :stairs_up
          @player.set_location(*Castle.up(*loc))
          return PlayerState::NEW_ROOM
        end
        @printer.stairs_up_error
        return PlayerState::ACTION
      when 'D'
        if rc.symbol == :stairs_down
          @player.set_location(*Castle.down(*loc))
          return PlayerState::NEW_ROOM
        end
        @printer.stairs_down_error
        return PlayerState::ACTION
      when 'DR'
        if rc.symbol == :magic_pool
          drink
          return PlayerState::DIED if @player.dead?
        else
          @printer.no_pool_error
        end
        return PlayerState::ACTION
      when 'M'
        @printer.display_map
        return PlayerState::ACTION
      when 'F'
        flare
        return PlayerState::ACTION
      when 'L'
        shine_lamp
        return PlayerState::ACTION
      when 'O'
        if rc.symbol == :book
          book
          @castle.set_in_room(*loc, :empty_room)
        elsif rc.symbol == :chest
          chest_effect = chest
          @castle.set_in_room(*loc, :empty_room)
          return PlayerState::DIED if @player.dead?
          return PlayerState::NEW_ROOM if chest_effect == :gas
        else
          @printer.nothing_to_open_error
        end
        return PlayerState::ACTION
      when 'G'
        if rc.symbol == :crystal_orb
          gaze
          return PlayerState::DIED if @player.dead?
        else
          @printer.no_crystal_orb_error
        end
        return PlayerState::ACTION
      when 'T'
        if @player.runestaff?
          teleport
          return PlayerState::NEW_ROOM
        else
          @printer.no_runestaff_error
          return PlayerState::ACTION
        end
      when 'Q'
        if @prompter.confirm('Y', @printer.prompt_confirm_quit)
          return PlayerState::QUIT
        end
        return PlayerState::ACTION
      else
        puts "UNRECOGNIZED COMMAND <#{cmd}>" # should never happen
      end

      PlayerState::ACTION
    end

    # This function was used during dev.
    # For some reason I'm hesitant to delete it, even though it's not used by anything.
    def debug_display_map
      floor = @player.location.last
      lines = []
      (1..8).each do |row|
        lines << ''
        (1..8).each do |col|
          c = @player.knows_room?(row, col, floor) ? @castle.room(row, col, floor).display : '?'
          lines.last << (@player.location == [row, col, floor]) ? "<#{c}>  " : " #{c}   "
        end
        lines << ''
      end
      lines << Strings.you_are_here(@player)
      puts lines
      puts
    end


    def random_drink_effect
      %i[stronger weaker smarter dumber nimbler clumsier change_race change_gender].sample
    end

    def random_drink_attr_change
      Random.rand(1..3)
    end

    def random_drink_race_change
      (Player::RACES - [@player.race]).sample
    end

    def drink
      effect = random_drink_effect
      case effect
      when :stronger
        @player.str(random_drink_attr_change)
      when :weaker
        @player.str(-1 * random_drink_attr_change)
      when :smarter
        @player.int(random_drink_attr_change)
      when :dumber
        @player.int(-1 * random_drink_attr_change)
      when :nimbler
        @player.dex(random_drink_attr_change)
      when :clumsier
        @player.dex(-1 * random_drink_attr_change)
      when :change_race
        newrace = random_drink_race_change
        @player.race = newrace
      when :change_gender
        newgender = @player.gender == :male ? :female : :male
        @player.gender = newgender
      else
        raise "unrecognized drink effect '#{effect}'"
      end

      @printer.drink_effect(effect)
    end


    def flare
      if @player.flares < 1
        @printer.out_of_flares
        return
      end

      @player.flares(-1)

      Castle.flare_locs(*@player.location).each do |loc|
        @player.remember_room(*loc)
      end

      @printer.flare
    end


    def shine_lamp
      unless @player.lamp?
        @printer.no_lamp_error
        return
      end
      dir = @prompter.ask(['N', 'E', 'W', 'S'], @printer.prompt_shine_lamp)
      target_loc = Castle.move(dir, *@player.location)
      @player.remember_room(*target_loc)
      @printer.lamp_shine(*target_loc)
    end


    def random_book_effect
      %i[flash poetry magazine dex_manual str_manual sticky].sample
    end

    def book
      effect = random_book_effect
      case effect
      when :flash
        @player.blind = true
      when :dex_manual
        @player.dex(+18)
      when :str_manual
        @player.str(+18)
      when :sticky
        @player.stickybook = true
      when :poetry, :magazine # rubocop:disable Lint/EmptyWhen
        # no effect
      else
        raise "unrecognized book effect '#{effect}'"
      end
      @printer.book_effect(effect)
    end


    def random_chest_effect
      %i[kaboom gold gas gold].sample
    end

    def chest_explosion_damage
      Random.rand(1..6)
    end

    def chest_gold
      Random.rand(1..1000)
    end

    def chest_gas_random_direction
      %i[n e w s].sample
    end

    def chest
      effect = random_chest_effect
      gold_gain = 0
      case effect
      when :kaboom
        dmg = chest_explosion_damage
        @player.take_a_hit!(dmg, @printer)
      when :gold
        gold_gain = chest_gold
        @player.gp(+gold_gain)
      when :gas
        dir = chest_gas_random_direction
        @player.turns(+20)
        @player.facing = dir
        @player.set_location(*Castle.move(dir.to_s.upcase, *@player.location))
      else
        raise "unrecognized chest effect '#{effect}'"
      end

      @printer.chest_effect(effect, gold_gain)
      effect
    end


    def random_gaze_effect
      %i[bloody_heap drink_and_become monster_gazing_back random_room zot_location soap_opera_rerun].sample
    end

    def random_gaze_attr_change
      Random.rand(1..2)
    end

    def random_gaze_show_orb_of_zot?
      Random.rand(2).zero?
    end

    def gaze
      effect = random_gaze_effect
      effect_location = nil
      case effect
      when :bloody_heap
        @player.str(-1 * random_gaze_attr_change)
      when :random_room
        effect_location = Castle.random_room
        @player.remember_room(*effect_location)
      when :zot_location
        effect_location = random_gaze_show_orb_of_zot? ? @castle.orb_of_zot_location : Castle.random_room
      when :drink_and_become, :monster_gazing_back, :soap_opera_rerun # rubocop:disable Lint/EmptyWhen
        # do nothing
      else
        raise "unrecognized gaze effect '#{effect}'"
      end

      @printer.gaze_effect(effect, effect_location)
    end


    def teleport
      row   = @prompter.ask_integer(1, 8, @printer.prompt_teleport_row)
      col   = @prompter.ask_integer(1, 8, @printer.prompt_teleport_column)
      floor = @prompter.ask_integer(1, 8, @printer.prompt_teleport_floor)
      @player.set_location(row, col, floor)
      @player.teleported = true
    end


    def combat
      loc = @player.location
      rc = @castle.room(*loc)

      outcome = run_battle(rc.monster_symbol)

      case outcome

      when BattleRunner::Result::RETREAT
        @printer.you_have_escaped
        dir = @prompter.ask(['N', 'S', 'E', 'W'], @printer.prompt_retreat_direction)
        @player.set_location(*Castle.move(dir, *loc))
        @player.facing = dir.downcase.to_sym
        return PlayerState::NEW_ROOM
      when BattleRunner::Result::PLAYER_DEAD
        return PlayerState::DIED
      when BattleRunner::Result::ENEMY_DEAD
        @printer.monster_is_dead
        eat_monster_maybe
        if rc.symbol == :vendor
          @player.armor = :plate
          @player.weapon = :sword
          @player.str(+Random.rand(1..6))
          @player.int(+Random.rand(1..6))
          @player.dex(+Random.rand(1..6))
          @player.lamp = true
          @printer.vendor_loot
        elsif rc.symbol == :runestaff_and_monster
          @printer.you_got_the_runestaff
          @player.runestaff = true
        end
        gp_gain = monster_random_gp
        @player.gp(+gp_gain)
        @printer.you_got_monster_gold(gp_gain)
        @castle.set_in_room(*loc, :empty_room)
        return PlayerState::ACTION
      when BattleRunner::Result::BRIBED
        @player.vendor_rage = false if rc.symbol == :vendor
        return PlayerState::ACTION
      else
        raise "illegal BattleRunner::Result '#{outcome}'"
      end
    end

    def run_battle(monster_symbol)
      br = BattleRunner.new(@player, monster_symbol, @printer, @prompter)
      br.run
    end

    def monster_random_gp
      Random.rand(1..1000)
    end

    def eat_monster_maybe
      return if @player.turns < @player.last_ate_turn + 60
      @printer.eat_a_monster
      @player.update_last_ate_turn!
    end

  end
end
