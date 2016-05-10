module TheWizardsCastle
class Runner



  def self.run
    runner = Runner.new
    runner.start
  end

  def initialize
    @prompter = Prompter.new
    @castle = nil
    @player = nil
  end

  def start
    puts Strings::INTRO
    # pause should go here?
    puts Strings::CHARACTER_CREATION_HEADER

    @player = Player.new
    ask_race
    puts
    ask_gender
    ask_attributes
    puts
    puts Strings::gold_report(@player)
    puts
    ask_armor
    puts Strings::gold_left_report(@player)
    ask_weapon
    puts
    ask_lamp
    puts
    puts Strings::gold_left_report(@player)  # this should be yet a different one! argh.
puts "todo: flare"

puts @player.inspect

    @castle = Castle.new
  end

  def ask_race
    allowed = {
      'E' => :elf,
      'D' => :dwarf,
      'M' => :human,
      'H' => :hobbit
    }
    n=0
    while @player.race.nil? && n+=1
      puts "\n"+Strings::RACE_ERROR if n>1
      answer = @prompter.ask(Strings::RACE_PROMPT)[0]
      @player.set_race(allowed[answer]) if allowed.has_key?(answer)
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

    puts
    puts Strings.attributes_prompt_header(@player,other_points)

    n=0
    while n+=1
      puts
      answer = @prompter.ask("#{'** ' if n>1}#{Strings::STRENGTH_PROMPT}")[0]
      next unless answer.match(/^\d+$/)
      answer = answer.to_i
      if answer>=0 && answer<=other_points
        other_points -= answer
        @player.str(+answer)
        break
      end
    end
    return if other_points < 1

    n=0
    while n+=1
      puts
      answer = @prompter.ask("#{'** ' if n>1}#{Strings::INTELLIGENCE_PROMPT}")[0]
      next unless answer.match(/^\d+$/)
      answer = answer.to_i
      if answer>=0 && answer<=other_points
        other_points -= answer
        @player.int(+answer)
        break
      end
    end
    return if other_points < 1

    n=0
    while n+=1
      puts
      answer = @prompter.ask("#{'** ' if n>1}#{Strings::DEXTERITY_PROMPT}")[0]
      next unless answer.match(/^\d+$/)
      answer = answer.to_i
      if answer>=0 && answer<=other_points
        other_points -= answer
        @player.dex(+answer)
        break
      end
    end
  end

  def ask_armor
    allowed = Player::ARMORS.collect{|x| [x.to_s[0].upcase,x]}.to_h
    costs = { plate: 30, chainmail: 20, leather: 10, nothing: 0 }
    n=0
    while @player.armor.nil? && n+=1
      puts "\n"+Strings.armor_error(@player) if n>1
      answer = @prompter.ask(Strings.armor_prompt)[0]
      if allowed.has_key?(answer)
        armor = allowed[answer]
        @player.set_armor(armor)
        @player.gp(-1 * costs[armor])
        break
      end
    end
  end

  def ask_weapon
    allowed = Player::WEAPONS.collect{|x| [x.to_s[0].upcase,x]}.to_h
    costs = { sword: 30, mace: 20, dagger: 10, nothing: 0 }
    n=0
    while @player.weapon.nil? && n+=1
      puts "\n"+Strings.weapon_error(@player) if n>1
      answer = @prompter.ask(Strings.weapon_prompt)[0]
      if allowed.has_key?(answer)
        weapon = allowed[answer]
        @player.set_weapon(weapon)
        @player.gp(-1 * costs[weapon])
        break
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
        break
      end
    end
  end

end
end
