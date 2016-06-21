module TheWizardsCastle
class Runner

  module PlayerState
    NEW_ROOM = :new_room
    ACTION = :action
    DIED = :died
    QUIT = :quit
    EXITED = :exited
  end

  def self.run
    runner = Runner.new
    runner.setup
    runner.character_creation
    runner.start
  end


  attr_accessor :prompter, :castle, :player, :printer


  def initialize
    @prompter = nil
    @castle = nil
    @player = nil
    @printer = nil
  end

  def setup(h={})
    @prompter = h[:prompter] || Prompter.new
    @castle = h[:castle] || Castle.new
    @player = h[:player] || Player.new
    @printer = h[:printer] || StetsonPrinter.new(@player)
  end

  def character_creation
    @printer.intro
    @printer.character_creation_header
    ask_race
    ask_gender
    ask_attributes
    @printer.gold_report1
    ask_armor
    @printer.gold_report2
    ask_weapon
    ask_lamp
    if @player.gp > 0
      @printer.gold_report3
      ask_flares
    end
  end

  def start
    @player.set_location(1,4,1) #entrance
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

    #TODO game over messaging
    puts "Game over because you #{status.to_s}."

    #TODO play again?
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
    @player.set_race(allowed[answer])

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
    @player.set_gender(allowed[answer])
  end


  def ask_attributes
    @printer.attributes_header
    ask_strength
    ask_intelligence
    ask_dexterity
  end

  def ask_strength
    if @player.custom_attribute_points > 0
      max = 18-@player.str
      max = @player.custom_attribute_points if max>@player.custom_attribute_points
      n = @prompter.ask_integer(0,max,@printer.prompt_add_to_strength)
      @player.custom_attribute_points(-n)
      @player.str(+n)
    end
  end

  def ask_intelligence
    if @player.custom_attribute_points > 0
      max = 18-@player.int
      max = @player.custom_attribute_points if max>@player.custom_attribute_points
      n = @prompter.ask_integer(0,max,@printer.prompt_add_to_intelligence)
      @player.custom_attribute_points(-n)
      @player.int(+n)
    end
  end

  def ask_dexterity
    if @player.custom_attribute_points > 0
      max = 18-@player.dex
      max = @player.custom_attribute_points if max>@player.custom_attribute_points
      n = @prompter.ask_integer(0,max,@printer.prompt_add_to_dexterity)
      @player.custom_attribute_points(-n)
      @player.dex(+n)
    end
  end


  def ask_armor
    #TODO this is only correct for char creation when you can afford everything
    # unaffordable choices should not be shown or allowed
    allowed = Player::ARMORS.collect{|x| [x.to_s[0].upcase,x]}.to_h
    costs = { plate: 30, chainmail: 20, leather: 10, nothing: 0 }
    answer = @prompter.ask(allowed.keys, @printer.prompt_armor)
    armor = allowed[answer]
    @player.set_armor(armor)
    @player.gp(-1 * costs[armor])
  end

  def ask_weapon
    #TODO this is only correct for char creation when you can afford everything
    # unaffordable choices should not be shown or allowed
    allowed = Player::WEAPONS.collect{|x| [x.to_s[0].upcase,x]}.to_h
    costs = { sword: 30, mace: 20, dagger: 10, nothing: 0 }
    answer = @prompter.ask(allowed.keys, @printer.prompt_weapon)
    weapon = allowed[answer]
    @player.set_weapon(weapon)
    @player.gp(-1 * costs[weapon])
  end

  def ask_lamp
    return if @player.gp < 20

    answer = @prompter.ask(["Y","N"], @printer.prompt_lamp)
    @player.gp(-20) if @player.set_lamp(answer=="Y")
  end

  def ask_flares
    return if @player.gp < 1
    n = @prompter.ask_integer(0,@player.gp,@printer.prompt_flares)
    @player.flares(+n)
    @player.gp(-n)
  end

  # End of character creation prompts
  #####################################


  def enter_room
    # returns a Player::Status

    if @player.blind?
      @printer.you_are_here_blind
    else
      @printer.you_are_here
    end

    @printer.stat_block

    # TODO @web_counter = 0

    loc = @player.location
    rc = @castle.room(*loc)

    @player.remember_room(*loc)

    symbol_for_text =
      if rc.symbol==:runestaff_and_monster
        @castle.runestaff_monster
      else
        rc.symbol
    end
    @printer.here_you_find(symbol_for_text)

    case rc.symbol
    when :gold
      n = Random.rand(10)+1
      @player.gp(+n)
      @printer.new_gold_count
      @castle.set_in_room(*loc,:empty_room)
      return PlayerState::ACTION
    when :flares
      n = Random.rand(5)+1
      @player.flares(+n)
      @printer.new_flare_count
      @castle.set_in_room(*loc,:empty_room)
      return PlayerState::ACTION
    when :warp
      @player.set_location *Castle.random_room
      return PlayerState::NEW_ROOM
    when :sinkhole
      @player.set_location *Castle.down(*loc)
      return PlayerState::NEW_ROOM
    when :orb_of_zot
#TODO no no no.  This should shunt.  Only get orb by teleporting in.
      @printer.found_orb_of_zot
      @player.set_runestaff(false)
      @player.set_orb_of_zot(true)
      @castle.set_in_room(*loc,:empty_room)
      return PlayerState::ACTION
    end

    if rc.treasure?
      @player.add_treasure(rc.symbol)
      @printer.got_a_treasure(rc.symbol)
      @castle.set_in_room(*loc,:empty_room)
      return PlayerState::ACTION
    elsif rc.monster? || (rc.symbol==:vendor && @player.vendor_rage?)
      # TODO fight!
    elsif rc.symbol==:vendor
      # TODO shop from vendor  line 6220
    end

    PlayerState::ACTION
  end

  def player_action
    # aka "MAIN PROCESSING LOOP" - basic line 2920

    @player.turns(+1)

    unless @player.runestaff? || @player.orb_of_zot?
      # TODO curses
      # if lethargy then @player.turns(+1)
      # if leech then @player.gp(-(Random.rand(5)-1)) #lose 1-5 gp
      # if forgetfulness then forget a random room

      # if room is cursed, set curse status on player


      # TODO when you regain sight, do you "learn" the current room
    end

    if Random.rand(5) == 0  # 20% chance
      # TODO random-flavor - line 3060
    end

    # TODO 3350 - check treasures to cure blindness or stickybook


    loc = @player.location
    rc = @castle.room(*loc)

    valid_cmds = ["H","N","S","E","W","U","D","DR","M","F","L","O","G","T","Q"]
    cmd = @prompter.ask(valid_cmds, @printer.prompt_standard_action)

#      if ['F','L','G','M'].include?(cmd) && @player.blind?
#        puts Strings.blind_command_error(@player)
#        puts
#        next
#      end

    case cmd
    when "H"
      @printer.help_message
      return PlayerState::ACTION
    when "N","S","E","W"
      if cmd=="N" && rc.symbol==:entrance
        return PlayerState::EXITED
      else
        @player.set_location *Castle.move(cmd,*loc)
        @player.set_facing(cmd.downcase.to_sym)
        return PlayerState::NEW_ROOM
      end
    when 'U'
      if rc.symbol==:stairs_up
        @player.set_location *Castle.up(*loc)
        return PlayerState::NEW_ROOM
      end
      @printer.stairs_up_error
      return PlayerState::ACTION
    when 'D'
      if rc.symbol==:stairs_down
        @player.set_location *Castle.down(*loc)
        return PlayerState::NEW_ROOM
      end
      @printer.stairs_down_error
      return PlayerState::ACTION
    when 'DR'
      if rc.symbol==:magic_pool
        drink
        return PlayerState::DIED if @player.str<1 || @player.int<1 || @player.dex<1
        return PlayerState::ACTION
      else
        @printer.drink_error
        return PlayerState::ACTION
      end
    when 'M'
      @printer.display_map(@castle)
      return PlayerState::ACTION
    when 'F'
      flare
      return PlayerState::ACTION
    when 'L'
      shine_lamp
      return PlayerState::ACTION

#      when 'O'
#        puts "<<cmd placeholder>>"  #TODO open chest/book
#      when 'G'
#        if rc.symbol==:crystal_orb
#          gaze
#        else
#          puts Strings.no_crystal_orb_error
#          puts
#        end
#        if @player.str<1 || @player.int<1 || @player.dex<1
#          @game_over = GameOverEnum::DIED
#          return
#        end
#      when 'T'
#        puts "<<cmd placeholder>>"  #TODO teleport
#      when 'Q'
#        #TODO real quit prompt
#        @game_over = PlayerState::QUIT
#        return
#      end
    else
      puts "UNRECOGNIZED COMMAND <#{cmd}>"  # should never happen
    end

    PlayerState::ACTION
  end
 


  def display_map
    floor = @player.location.last
    lines = []
    (1..8).each do |row|
      lines << ''
      (1..8).each do |col|
        c = @player.knows_room?(row,col,floor) ? @castle.room(row,col,floor).display : "?"
        if [row,col,floor]==@player.location
          lines.last << "<#{c}>  "
        else
          lines.last << " #{c}   "
        end
      end
      lines << ""
    end
    lines << Strings.you_are_here(@player)
    puts lines
    puts
  end

  def random_drink_effect
    [:stronger,:weaker,:smarter,:dumber,:nimbler,:clumsier,:change_race,:change_gender].sample
  end

  def random_drink_attr_change
    1+Random.rand(3)
  end

  def random_drink_race_change
    (Player::RACES - [@player.race]).sample
  end

  def drink
    effect = random_drink_effect()
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
      newrace = random_drink_race_change()
      @player.set_race(newrace)
    when :change_gender
      newgender = @player.gender==:male ? :female : :male
      @player.set_gender(newgender)
    else
      raise "unrecognized drink effect '#{effect.to_s}'"
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
      # TODO should I remember the center room?
    end

    @printer.flare(@castle)
  end


  def shine_lamp
    unless @player.lamp?
      @printer.no_lamp_error
      return
    end
    dir = @prompter.ask(["N","E","W","S"], @printer.prompt_shine_lamp)
    target_loc = Castle.move(dir,*@player.location)
    @player.remember_room(*target_loc)
    @printer.lamp_shine(*target_loc,@castle)
  end


  def gaze
    s = "YOU SEE "
    case Random.rand(6)
    when 0
      @player.str(-1*Random.rand(2))
      s += "YOURSELF IN A BLOODY HEAP!"
    when 1
      s += "YOURSELF DRINKING FROM A POOL AND BECOMING #{Strings.random_monster_text}!"
    when 2
      s += "#{Strings.random_monster_text} GAZING BACK AT YOU!"
    when 3
      # a random room
      xloc = Castle.random_room
      xrc = @castle.room(*xloc)
      @player.remember_room(*xloc)
      s += "#{xrc.text} AT ( #{xloc[0]} , #{xloc[1]} ) LEVEL #{xloc[2]} ."
    when 4
      zot_loc = Castle.random_room
      if Random.rand(2)==0
        zot_loc = @castle.orb_of_zot_location
      end
      s += "***THE ORB OF ZOT*** AT ( #{zot_loc[0]} , #{zot_loc[1]} ) LEVEL #{zot_loc[2]} ."
    when 5
      s += "A SOAP OPERA RERUN!"
    end
    puts s
    puts
  end


end
end
