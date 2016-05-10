module TheWizardsCastle
class Runner



  def self.run
    runner = Runner.new
    runner.start
  end

  def initialize
    @cli = HighLine.new
    @castle = nil
    @player = nil
  end

  def start
    puts Strings::INTRO
    # pause should go here
    puts Strings::CHARACTER_CREATION_HEADER

    @player = Player.new
    ask_race
    ask_gender
    ask_attributes
#shop armor
#shop weapon
#shop lamp
#shop flare

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
      answer = @cli.ask(Strings::RACE_PROMPT).to_s.upcase[0]
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
      puts Strings.gender_error(@player.race) if n>1
      answer = @cli.ask(Strings::GENDER_PROMPT).to_s.upcase[0]
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
      answer = @cli.ask("#{'** ' if n>1}#{Strings::STRENGTH_PROMPT}").to_s.strip
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
      answer = @cli.ask("#{'** ' if n>1}#{Strings::INTELLIGENCE_PROMPT}").to_s.strip
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
      answer = @cli.ask("#{'** ' if n>1}#{Strings::DEXTERITY_PROMPT}").to_s.strip
      next unless answer.match(/^\d+$/)
      answer = answer.to_i
      if answer>=0 && answer<=other_points
        other_points -= answer
        @player.dex(+answer)
        break
      end
    end
  end

end
end
