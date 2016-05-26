module TheWizardsCastle
class Runner

  module GameOverEnum
    DIED = :died
    QUIT = :quit
    EXITED = :exited
  end

  def self.run
    runner = Runner.new
    runner.start
  end

  def initialize
    @prompter = Prompter.new
    @castle = nil
    @player = nil
    @last_direction = nil
    @game_over = nil
  end

  def start
    puts Strings::INTRO
    # pause should go here?
    puts Strings::CHARACTER_CREATION_HEADER

    @player = Player.new
    ask_race
    ask_gender
    ask_attributes
    puts Strings.gold_report1(@player)
    puts
    ask_armor
    puts Strings.gold_report2(@player)
    puts
    ask_weapon
    ask_lamp
    if @player.gp > 0
      puts Strings.gold_report3(@player)
      puts
      ask_flares
    end
    puts Strings.entering_the_castle(@player)
    puts

    @castle = Castle.new
    @last_direction = "N" #needed by the Orb-of-Zot shunt
    @game_over = nil

    loop do
      run_new_location
      break if @game_over
    end

    #TODO this message
    puts "Game over because you #{@game_over.to_s}."

    #TODO play again?
  end


  def run_new_location
    # The player enters a new room.

    loc = @player.location
    rc = @castle.room(*loc)
puts ">>> #{rc.symbol}"

    @player.remember_room(*loc)
    # TODO exact Orb of Zot behavior

    puts Strings.you_are_here(@player)
    puts
    puts Strings.stat_block(@player)
    puts

    symbol_for_text =
      if rc.symbol==:runestaff_and_monster
        @castle.runestaff_monster
      else
        rc.symbol
    end
    puts Strings.here_you_find(symbol_for_text)
    puts


    ###   Room-entry events (pre-user action)
    case rc.symbol
    when :gold
      n = Random.rand(10)+1
      puts Strings.you_now_have("#{@player.gp(+n)} GOLD")
      puts
      @castle.set_in_room(*loc,:empty_room)
    when :flares
      n = Random.rand(5)+1
      puts Strings.you_now_have("#{@player.flares(+n)} FLARES")
      puts
      @castle.set_in_room(*loc,:empty_room)
    when :warp
      @player.set_location *Castle.random_room
      return
    when :sinkhole
      @player.set_location *Castle.down(*loc)
      return
    else
      if rc.treasure?
        # TODO take it
      elsif rc.monster? || (rc.symbol==:vendor && @player.vendor_rage?)
        # TODO fight!
      end
    end


    ###   User-command loop
    loop do
      cmd = @prompter.ask(Strings.standard_action_prompt)[0]
      puts
      case cmd
      when 'N','S','E','W'
        if cmd=='N' && rc.symbol==:entrance
          @game_over = GameOverEnum::EXITED
          return
        end
        @last_direction = cmd
        @player.set_location *Castle.move(cmd,*loc)
        return
      when 'M'
        display_map
      when 'Q'
        @game_over = GameOverEnum::QUIT
        return
      when 'H','U','D','DR','M','F','L','O','G','T'
        puts "Command not implemented yet"
      else
        puts Strings.standard_action_error(@player)
        puts
      end
    end
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


  # Character creation prompts

  def ask_race
    allowed = {
      'E' => :elf,
      'D' => :dwarf,
      'M' => :human,
      'H' => :hobbit
    }
    n=0
    while @player.race.nil? && n+=1
      puts Strings::RACE_ERROR if n>1
      answer = @prompter.ask(Strings::RACE_PROMPT)[0]
      @player.set_race(allowed[answer]) if allowed.has_key?(answer)
      puts
    end
  end

  def ask_gender
    allowed = {
      'M' => :male,
      'F' => :female
    }
    n=0
    while @player.gender.nil? && n+=1
      puts Strings.gender_error(@player) if n>1
      answer = @prompter.ask(Strings::GENDER_PROMPT)[0]
      @player.set_gender(allowed[answer]) if allowed.has_key?(answer)
    end
    puts
  end

  def ask_attributes
    other_points = 0
    case @player.race
    when :hobbit
      @player.str(+4)
      @player.int(+8)
      @player.dex(+12)
      other_points = 4
    when :elf
      @player.str(+6)
      @player.int(+8)
      @player.dex(+10)
      other_points = 8
    when :human
      @player.str(+8)
      @player.int(+8)
      @player.dex(+8)
      other_points = 8
    when :dwarf
      @player.str(+10)
      @player.int(+8)
      @player.dex(+6)
      other_points = 8
    end

    puts Strings.attributes_prompt_header(@player,other_points)

    n=0
    while n+=1
      puts
      answer = @prompter.ask("#{'** ' if n>1}#{Strings::STRENGTH_PROMPT}")
      next unless answer.match(/^\d+$/)
      answer = answer.to_i
      if answer>=0 && answer<=other_points
        other_points -= answer
        @player.str(+answer)
        break
      end
    end
    if other_points < 1
      puts
      return
    end

    n=0
    while n+=1
      puts
      answer = @prompter.ask("#{'** ' if n>1}#{Strings::INTELLIGENCE_PROMPT}")
      next unless answer.match(/^\d+$/)
      answer = answer.to_i
      if answer>=0 && answer<=other_points
        other_points -= answer
        @player.int(+answer)
        break
      end
    end
    if other_points < 1
      puts
      return
    end

    n=0
    while n+=1
      puts
      answer = @prompter.ask("#{'** ' if n>1}#{Strings::DEXTERITY_PROMPT}")
      next unless answer.match(/^\d+$/)
      answer = answer.to_i
      if answer>=0 && answer<=other_points
        other_points -= answer
        @player.dex(+answer)
        break
      end
    end
    puts
  end

  def ask_armor
    allowed = Player::ARMORS.collect{|x| [x.to_s[0].upcase,x]}.to_h
    costs = { plate: 30, chainmail: 20, leather: 10, nothing: 0 }
    n=0
    while @player.armor.nil? && n+=1
      puts Strings.armor_error(@player)+"\n\n" if n>1
      answer = @prompter.ask(Strings.armor_prompt)[0]
      puts
      if allowed.has_key?(answer)
        armor = allowed[answer]
        @player.set_armor(armor)
        @player.gp(-1 * costs[armor])
      end
    end
  end

  def ask_weapon
    allowed = Player::WEAPONS.collect{|x| [x.to_s[0].upcase,x]}.to_h
    costs = { sword: 30, mace: 20, dagger: 10, nothing: 0 }
    n=0
    while @player.weapon.nil? && n+=1
      puts Strings.weapon_error(@player)+"\n\n" if n>1
      answer = @prompter.ask(Strings.weapon_prompt)[0]
      puts
      if allowed.has_key?(answer)
        weapon = allowed[answer]
        @player.set_weapon(weapon)
        @player.gp(-1 * costs[weapon])
      end
    end
  end

  def ask_lamp
    if @player.gp < 20
      @player.set_lamp(false)
      return
    end

    n=0
    while n+=1
      puts "\n#{Strings::YESNO_ERROR}\n" if n>1
      answer = @prompter.ask(Strings::LAMP_PROMPT)[0]
      if answer=="Y" || answer=="N"
        @player.gp(-20) if @player.set_lamp(answer=="Y")
        puts
        break
      end
    end
  end

  def ask_flares
    return if @player.gp < 1
    loop do
      answer = @prompter.ask(Strings::FLARE_PROMPT)
      puts
      n = answer.to_i
      if !answer.match(/^\d+$/)
        puts Strings::FLARE_ERROR
      elsif n > @player.gp
        puts Strings.flare_afford(@player)
      else
        @player.flares(+n)
        @player.gp(-n)
        break
      end
    end
  end

end
end
