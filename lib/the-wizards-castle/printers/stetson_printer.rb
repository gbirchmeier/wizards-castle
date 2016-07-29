module TheWizardsCastle
class StetsonPrinter

  def initialize(player,castle)
    @player = player
    @castle = castle
  end







  def intro
    s =<<END_INTRO
****************************************************************

               * * * THE WIZARD'S CASTLE * * *

****************************************************************

MANY CYCLES AGO, IN THE KINGDOM OF N'DIC, THE GNOMIC
WIZARD ZOT FORGED HIS GREAT *ORB OF POWER*. HE SOON
VANISHED, LEAVING BEHIND HIS VAST SUBTERRANEAN CASTLE
FILLED WITH ESURIENT MONSTERS, FABULOUS TREASURES, AND
THE INCREDIBLE *ORB OF ZOT*. FROM THAT TIME HENCE, MANY
A BOLD YOUTH HAS VENTURED INTO THE WIZARD'S CASTLE. AS
OF NOW, *NONE* HAS EVER EMERGED VICTORIOUSLY! BEWARE!!

END_INTRO
    puts s
  end

  def character_creation_header
    sleep 3  #simulate BASIC's delay
    beep
    puts "ALL RIGHT, BOLD ONE."
  end


  def prompt_race
    { prompt:  "YOU MAY BE AN ELF, DWARF, MAN, OR HOBBIT.\n\nYOUR CHOICE? ",
      error:   "\n** THAT WAS INCORRECT. PLEASE TYPE E, D, M, OR H.\n",
      success: "\n"
    }
  end

  def prompt_gender
    { prompt:  "WHICH SEX TO YOU PREFER? ",
      error:   "** CUTE #{player_race}, REAL CUTE. TRY M OR F.\n",
      success: "\n"
    }
  end

  def attributes_header
    s =<<END_ATT_HEADER
OK, #{player_race}, YOU HAVE THE FOLLOWING ATTRIBUTES :
STRENGTH = #{@player.str}  INTELLIGENCE = #{@player.int}  DEXTERITY = #{@player.dex}
AND #{@player.custom_attribute_points} OTHER POINTS TO ALLOCATE AS YOU WISH.

END_ATT_HEADER
    print s
  end
    
  def prompt_add_to_strength
    return prompt_add_to_attribute("STRENGTH")
  end

  def prompt_add_to_intelligence
    return prompt_add_to_attribute("INTELLIGENCE")
  end

  def prompt_add_to_dexterity
    return prompt_add_to_attribute("DEXTERITY")
  end

  def gold_report1
    puts "OK, #{player_race}, YOU HAVE #{@player.gp} GOLD PIECES (GP'S)."
    puts
  end

  def gold_report2
    puts "OK, BOLD #{player_race}, YOU HAVE #{@player.gp} GP'S LEFT."
    puts
  end

  def gold_report3
    puts "OK, #{player_race}, YOU HAVE #{@player.gp} GOLD PIECES LEFT."
    puts
  end


  def prompt_armor
    prompt =  "THESE ARE THE TYPES OF ARMOR YOU CAN BUY :\n" +
              "PLATE<30> CHAINMAIL<20> LEATHER<10> NOTHING<0>\n" +
              "\n" + "YOUR CHOICE? "
    { prompt: prompt,
      error: Proc.new { "\n** ARE YOU A #{player_race} OR #{random_monster_text}?\n\n" },
      success: "\n"
    }
  end

  def prompt_weapon
    prompt = "THESE ARE THE TYPES OF WEAPONS YOU CAN BUY :\n" +
             "SWORD<30> MACE<20> DAGGER<10> NOTHING<0>\n" +
             "\n" + "YOUR CHOICE? "
    { prompt: prompt,
      error: "** IS YOUR IQ REALLY #{@player.int} ?\n\n",
      success: "\n"
    }
  end


  def prompt_lamp
    { prompt: "DO YOU WANT TO BUY A LAMP FOR 20 GP'S? ",
      error: "** PLEASE ANSWER YES OR NO\n\n",
      success: "\n"
    }
  end


  def prompt_flares
    { prompt: "FLARES COST 1 GP EACH. HOW MANY DO YOU WANT? ",
      success: "\n",
      error: "\n** IF YOU DON'T WANT ANY, JUST TYPE 0 (ZERO).\n\n",
      out_of_range: "\n** YOU CAN ONLY AFFORD #{@player.gp} .\n\n"
    }
  end


  def entering_the_castle
    puts "OK, #{player_race}, YOU ARE NOW ENTERING THE CASTLE!"
    puts
  end

  def you_are_here
    row,col,floor = @player.location
    puts "YOU ARE AT ( #{row} , #{col} ) LEVEL #{floor} ."
    puts
  end

  def you_are_here_blind
    puts
  end

  def stat_block
    s =<<END_STAT_BLOCK
STRENGTH = #{@player.str}  INTELLIGENCE = #{@player.int}  DEXTERITY = #{@player.dex}
TREASURES = #{@player.treasure_count}  FLARES = #{@player.flares}  GOLD PIECES = #{@player.gp}
WEAPON = #{@player.weapon.to_s.upcase}  ARMOR = #{@player.armor.to_s.upcase}
END_STAT_BLOCK
    s.chomp!
    s << "  AND A LAMP" if @player.lamp?
    s << "\n\n"
    print s
  end

  def here_you_find(symbol)
    puts "HERE YOU FIND #{RoomContent::ROOM_THINGS[symbol][:text]}."
    puts
  end


  def new_gold_count
    puts "YOU NOW HAVE #{@player.gp} GOLD"
    puts
  end

  def new_flare_count
    puts "YOU NOW HAVE #{@player.flares} FLARES"
    puts
  end


  def found_orb_of_zot
    puts "GREAT UNMITIGATED ZOT!"
    puts
    puts "YOU JUST FOUND ***THE ORB OF ZOT***!"
    puts
    puts "THE RUNESTAFF HAS DISAPPEARED!"
    puts
  end


  def got_a_treasure(treasure_symbol)
    puts "IT'S NOW YOURS!"
    puts
  end


  def player_action_flavor_text
    rnd = 1+Random.rand(7)
    rnd +=1 if @player.blind?
    rnd=4 if rnd>7
    # ^^ pretty stupid, right?  But that's just how the BASIC impl does it.

    case rnd
    when 1 then puts "YOU SEE A BAT FLY BY!"
    when 2 then puts "YOU HEAR #{["A SCREAM!","FOOTSTEPS!","A WUMPUS!","THUNDER!"].sample}"
    when 3 then puts "YOU SNEEZED!"
    when 4 then puts "YOU STEPPED ON A FROG!"
    when 5 then puts "YOU SMELL #{random_monster_text} FRYING!"
    when 6 then puts "YOU FEEL LIKE YOU'RE BEING WATCHED!"
    when 7 then puts "YOU HEAR FAINT RUSTLING NOISES!"
    end
    puts
  end


  def cure_blindness
    puts "THE OPAL EYE CURES YOUR BLINDNESS!"
    puts
  end

  def cure_stickybook
    puts "THE BLUE FLAME DISSOLVES THE BOOK!"
    puts
  end


  def prompt_standard_action
    { prompt:  "ENTER YOUR COMMAND : ",
      error:   "\n** SILLY #{player_race}, THAT WASN'T A VALID COMMAND!\n\n",
      success: Proc.new {|x| x[0]=="F" ? '' : x=="T" ? "\n\n" : "\n" }
    }
  end


  def blind_command_error
    puts "** YOU CAN'T SEE ANYTHING, YOU DUMB #{player_race}!"
    puts
  end

  def help_message
    s=<<END_HELP
*** WIZARD'S CASTLE COMMAND AND INFORMATION SUMMARY ***

THE FOLLOWING COMMANDS ARE AVAILABLE :

H/ELP     N/ORTH    S/OUTH    E/AST     W/EST     U/P
D/OWN     DR/INK    M/AP      F/LARE    L/AMP     O/PEN
G/AZE     T/ELEPORT Q/UIT

THE CONTENTS OF ROOMS ARE AS FOLLOWS :

. = EMPTY ROOM      B = BOOK            C = CHEST
D = STAIRS DOWN     E = ENTRANCE/EXIT   F = FLARES
G = GOLD PIECES     M = MONSTER         O = CRYSTAL ORB
P = MAGIC POOL      S = SINKHOLE        T = TREASURE
U = STAIRS UP       V = VENDOR          W = WARP/ORB

THE BENEFITS OF HAVING TREASURES ARE :

RUBY RED - AVOID LETHARGY     PALE PEARL - AVOID LEECH
GREEN GEM - AVOID FORGETTING  OPAL EYE - CURES BLINDNESS
BLUE FLAME - DISSOLVES BOOKS  NORN STONE - NO BENEFIT
PALANTIR - NO BENEFIT         SILMARIL - NO BENEFIT

PRESS RETURN WHEN READY TO RESUME, #{player_race}.
END_HELP
    print s.chomp
    gets
    puts
  end


  def stairs_up_error
    puts "** THERE ARE NO STAIRS GOING UP FROM HERE!"
    puts
  end

  def stairs_down_error
    puts "** THERE ARE NO STAIRS GOING DOWN FROM HERE!"
    puts
  end

  def drink_effect(effect)
    s = "YOU TAKE A DRINK AND "
    case effect
    when :stronger
      s+="FEEL STRONGER."
    when :weaker
      s+="FEEL WEAKER"
    when :smarter
      s+="FEEL SMARTER."
    when :dumber
      s+="FEEL DUMBER."
    when :nimbler
      s+="FEEL NIMBLER."
    when :clumsier
      s+="FEEL CLUMSIER."
    when :change_race
      s+="BECOME A #{player_race}."
    when :change_gender
      s+="TURN INTO A #{player_gender} #{player_race}!"
    else
      s+="<ERROR - unrecognized effect '#{effect}.to_s'>"
    end
    puts s
    puts
  end

  def no_pool_error
    puts "** IF YOU WANT A DRINK, FIND A POOL!"
    puts
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
    end
    puts lines
    puts
    self.you_are_here
  end


  def flare
    locs = Castle.flare_locs(*@player.location)
    3.times do
      line = ""
      3.times do 
        loc = locs.shift
        c = @castle.room(*loc).display
        line << " #{c}   "
      end
      puts
      puts line
      puts
    end
    self.you_are_here
  end

  def out_of_flares
    puts "** HEY, BRIGHT ONE, YOU'RE OUT OF FLARES!"
    puts
  end

  def prompt_shine_lamp
    { prompt: "WHERE DO YOU WANT TO SHINE THE LAMP (N,S,E,W)? ",
      error: "\n** THAT'S NOT A DIRECTION, #{player_race}!\n\n",
      success: "\n"
    }
  end

  def no_lamp_error
    puts "** YOU DON'T HAVE A LAMP, #{player_race}!"
    puts
  end

  def lamp_shine(row,col,floor)
    puts "THE LAMP SHINES INTO ( #{row} , #{col} ) LEVEL #{floor} ."
    puts
    puts "THERE YOU WILL FIND #{@castle.room(row,col,floor).text}."
    puts
  end


  def nothing_to_open_error
    puts "** THE ONLY THING OPENED WAS YOUR BIG MOUTH!"
    puts
  end

  def book_effect(effect)
    puts "YOU OPEN THE BOOK AND"
    case effect
    when :flash
      puts "FLASH! OH NO! YOU ARE NOW A BLIND #{player_race}!"
    when :poetry
      puts "IT'S ANOTHER VOLUME OF ZOT'S POETRY! - YECH!!"
    when :magazine
      puts "IT'S AN OLD COPY OF PLAY#{random_race}!"
    when :dex_manual
      puts "IT'S A MANUAL OF DEXTERITY!"
    when :str_manual
      puts "IT'S A MANUAL OF STRENGTH!"
    when :sticky
      puts "THE BOOK STICKS TO YOUR HANDS -"
      puts "NOW YOU ARE UNABLE TO DRAW YOUR WEAPON!"
    else
      puts "<ERROR - unrecognized effect '#{effect.to_s}'"
    end
    puts
  end

  def chest_effect(effect,gold_gain)
    puts "YOU OPEN THE CHEST AND"
    case effect
    when :kaboom
      puts "KABOOM! IT EXPLODES!!"
    when :gold
      puts "FIND #{gold_gain} GOLD PIECES!"
    when :gas
      puts "GAS!! YOU STAGGER FROM THE ROOM!"
    else
      raise "unrecognized chest effect '#{effect.to_s}'"
    end
    puts
  end

  def gaze_effect(effect,effect_location)
    s = "YOU SEE "
    case effect
    when :bloody_heap
      s+="YOURSELF IN A BLOODY HEAP!"
    when :drink_and_become
      s+="YOURSELF DRINKING FROM A POOL AND BECOMING #{random_monster_text}!"
    when :monster_gazing_back
      s+="#{random_monster_text} GAZING BACK AT YOU!"
    when :random_room
      rc = @castle.room(*effect_location)
      s+="#{rc.text} AT ( #{effect_location[0]} , #{effect_location[1]} ) LEVEL #{effect_location[2]} ."
    when :zot_location
      s+="***THE ORB OF ZOT*** AT ( #{effect_location[0]} , #{effect_location[1]} ) LEVEL #{effect_location[2]} ."
    when :soap_opera_rerun
      s+="A SOAP OPERA RERUN!"
    else
      s+="<ERROR - unrecognized effect '#{effect.to_s}'>"
    end
    puts s
    puts
  end

  def no_crystal_orb_error
    puts "** IT'S HARD TO GAZE WITHOUT AN ORB!"
    puts
  end

  def no_runestaff_error
    puts "** YOU CAN'T TELEPORT WITHOUT THE RUNESTAFF!"
    puts
  end

  def prompt_teleport_row
    { prompt: "X-COORDINATE? ",
      success: "\n",
      error: "\n** TRY A NUMBER FROM 1 TO 8.\n\n",
      out_of_range: "\n** TRY A NUMBER FROM 1 TO 8.\n\n"
    }
  end

  def prompt_teleport_column
    { prompt: "Y-COORDINATE? ",
      success: "\n",
      error: "\n** TRY A NUMBER FROM 1 TO 8.\n\n",
      out_of_range: "\n** TRY A NUMBER FROM 1 TO 8.\n\n"
    }
  end

  def prompt_teleport_floor
    { prompt: "Z-COORDINATE? ",
      success: "\n",
      error: "\n** TRY A NUMBER FROM 1 TO 8.\n\n",
      out_of_range: "\n** TRY A NUMBER FROM 1 TO 8.\n\n"
    }
  end


  def prompt_confirm_quit
    { prompt: "DO YOU REALLY WANT TO QUIT NOW? ",
      confirmed: "\n\n",
      denied: "\n** THEN DON'T SAY THAT YOU DO!\n\n",
    }
  end




  #########################################
  # ENDGAME

  def death
    beep
    puts "*" * 62
    puts
    puts "A NOBLE EFFORT, OH FORMERLY LIVING #{player_race}"
    puts
    print "YOU DIED DUE TO LACK OF "
    # Yes, if two stats hit 0 at once, this will print two attributes.
    # This is authentic to the original BASIC.
    puts "STRENGTH." if @player.str<1
    puts "INTELLIGENCE." if @player.int<1
    puts "DEXTERITY." if @player.dex<1
    puts
    puts "AT THE TIME YOU DIED, YOU HAD :"
  end

  def quit
    puts
    puts "A LESS THAN AWE-INSPIRING DEFEAT."
    puts
    puts "WHEN YOU LEFT THE CASTLE, YOU HAD :"
    puts "YOUR MISERABLE LIFE!"
  end

  def exit_castle
    if @player.orb_of_zot?
      puts "YOU LEFT THE CASTLE WITH THE ORB OF ZOT."
      puts
      puts
      puts "AN INCREDIBLY GLORIOUS VICTORY!!"
      puts "IN ADDITION, YOU GOT OUT WITH THE FOLLOWING :"
    else
      puts "YOU LEFT THE CASTLE WITHOUT THE ORB OF ZOT."
      puts
      puts
      puts "A LESS THAN AWE-INSPIRING DEFEAT."
      puts
      puts "WHEN YOU LEFT THE CASTLE, YOU HAD :"
    end
    puts "YOUR MISERABLE LIFE!"
  end

  def endgame_possessions
    weapon = @player.weapon==:nothing ? "NO WEAPON" : @player.weapon.to_s.upcase
    armor =  @player.armor==:nothing  ? "NO ARMOR"  : @player.armor.to_s.upcase
    lamp = @player.lamp? ? " AND A LAMP" : ""

    puts "THE RUBY RED" if @player.have_treasure? :ruby_red
    puts "THE NORN STONE" if @player.have_treasure? :norn_stone
    puts "THE PALE PEARL" if @player.have_treasure? :pale_pearl
    puts "THE OPAL EYE" if @player.have_treasure? :opal_eye
    puts "THE GREEN GEM" if @player.have_treasure? :green_gem
    puts "THE BLUE FLAME" if @player.have_treasure? :blue_flame
    puts "THE PALANTIR" if @player.have_treasure? :palantir
    puts "THE SILMARIL" if @player.have_treasure? :silmaril
    puts "#{weapon} AND #{armor}#{lamp}"
    puts "YOU ALSO HAD #{@player.flares} FLARES AND #{@player.gp} GOLD PIECES"
    puts "AND THE RUNESTAFF" if @player.runestaff?
    puts
    puts "AND IT TOOK YOU #{@player.turns} TURNS!"
    puts
  end

  def prompt_play_again
    { prompt: "ARE YOU FOOLISH ENOUGH TO WANT TO PLAY AGAIN? ",
      error: "** PLEASE ANSWER YES OR NO\n",
      success: "\n"
    }
  end

  def play_again
    puts "SOME #{player_race}S NEVER LEARN!"
    puts
  end

  def restock
    puts "PLEASE BE PATIENT WHILE THE CASTLE IS RESTOCKED."
    puts
  end

  def shut_down
    puts "MAYBE DUMB #{player_race} IS NOT SO DUMB AFTER ALL!"
    puts
  end


  #########################################
  # COMBAT

  def you_have_escaped
    puts "YOU HAVE ESCAPED!"
    puts
  end

  def prompt_retreat_direction
    { prompt: "DO YOU WANT TO GO NORTH, SOUTH, EAST, OR WEST?",
      error: "\n** DON'T PRESS YOUR LUCK, #{player_race}!\n\n",
      success: "\n"
    }
  end

  def youre_facing_a_monster
    puts "YOU'RE FACING #{room_monster}!"
    puts
  end

  def combat_menu(can_bribe)
    puts "YOU MAY ATTACK OR RETREAT."
    puts "YOU CAN ALSO ATTEMPT A BRIBE." if can_bribe
    puts "YOU CAN ALSO CAST A SPELL." if @player.int > 14
    puts
  end

  def your_battle_stats
    puts "YOUR STRENGTH IS #{@player.str} AND YOUR DEXTERITY IS #{@player.dex} ."
    puts
  end

  def combat_selection_error_msg
    puts "** CHOOSE ONE OF THE OPTIONS LISTED."
    puts
  end

  def prompt_combat
    { prompt: "YOUR CHOICE? ",
      success: "\n"
      # error is ignored in this one
    }
  end


  def the_monster_attacks
    puts "THE #{room_monster_no_article} ATTACKS!"
    puts
  end

  def he_hit_you
    puts "OUCH! HE HIT YOU!"
    puts
  end

  def he_missed_you
    puts "WHAT LUCK, HE MISSED YOU!"
    puts
  end

  def armor_destroyed
    puts "YOUR ARMOR HAS BEEN DESTROYED . . . GOOD LUCK!"
    puts
  end

  def monster_is_dead
    puts "#{room_monster} LIES DEAD AT OUR FEET!"
    puts
  end


  def unarmed_attack
    puts "** POUNDING ON #{room_monster} WON'T HURT IT!"
    puts
  end

  def book_attack
    puts "** YOU CAN'T BEAT IT TO DEATH WITH A BOOK!"
    puts
  end

  def you_hit_him
    puts "YOU HIT THE EVIL #{room_monster}!"
    puts
  end

  def your_weapon_broke
    puts "OH NO! YOUR #{@player.weapon.to_s.upcase} BROKE!"
    puts
  end

  def eat_a_monster
    recipe = ["SANDWICH","STEW","SOUP","BURGER","ROAST","FILET","TACO","PIE"].sample
    puts "YOU SPEND AN HOUR EATING #{room_monster} #{recipe}."
    puts
  end

  def you_got_the_runestaff
    beep
    puts "GREAT ZOT! YOU'VE FOUND THE RUNESTAFF!"
    puts
  end

  def you_got_monster_gold(n)
    puts "YOU NOW GET HIS HOARD OF #{n} GP's"
    puts
  end


  def bribe_refused
    puts "ALL I WANT IS YOUR LIFE!"
    puts
  end

  def prompt_bribe_request(treasure_symbol)
    treasure_text = RoomContent::ROOM_THINGS[treasure_symbol][:text]
    { prompt: "I WANT #{treasure_text}. WILL YOU GIVE IT TO ME? ",
      error:  "** PLEASE ANSWER YES OR NO\n\n",
      success: "\n"
    }
  end

  def bribe_accepted
    puts "OK, JUST DON'T TELL ANYONE ELSE."
    puts
  end


  def cant_cast_now
    puts "** YOU CAN'T CAST A SPELL NOW!"
    puts
  end

  def prompt_cast
    { prompt: "WHICH SPELL (WEB, FIREBALL, DEATHSPELL)? ",
      success: Proc.new {|x| x[0]=="W" ? "\n\n" : "\n"}
      # error is ignored in this one
    }
  end

  def cast_selection_error_msg
    puts
    puts "** TRY ONE OF THE OPTIONS GIVEN."
    puts
  end

  def the_web_broke
    puts "THE WEB JUST BROKE!"
    puts
  end

  def monster_stuck_in_web
    puts
    puts "THE #{room_monster} IS STUCK AND CAN'T ATTACK NOW!"
    puts
  end

  def fireball_damage_report(n)
    puts "IT DOES #{n} POINTS WORTH OF DAMAGE."
    puts
    puts
  end

  def deathspell_kills_enemy
    puts "DEATH . . . HIS!"
    puts
  end

  def deathspell_kills_player
    puts "DEATH . . . YOURS!"
    puts
  end


  #########################################
  # VENDOR

  def prompt_vendor_encounter
    { prompt: "YOU MAY TRADE WITH, ATTACK, OR IGNORE THE VENDOR.\n\nYOUR CHOICE? ",
      success: "\n",
      error: "** NICE SHOT, #{player_race}!\n\n"
    }
  end

  def vendor_responds_to_attack
    puts "YOU'LL BE SORRY THAT YOU DID THAT!"
    puts
  end

private
  def player_race
    @player.race.to_s.upcase
  end

  def player_gender
    @player.gender.to_s.upcase
  end

  def random_monster_text
    RoomContent::ROOM_THINGS[Castle::MONSTERS.sample][:text]
  end

  def random_race
    Player::RACES.sample.to_s.upcase
  end

  def prompt_add_to_attribute(att)
    s = "HOW MANY POINTS DO YOU WISH TO ADD TO YOUR #{att}? "
    { prompt: s,
      success: "\n",
      error: "\n** ",
      out_of_range: "\n** "
    }
  end

  def beep
    print "\a"
  end

  def room_monster
    rc = @castle.room( *@player.location )
    rc.text
  end

  def room_monster_no_article
    room_monster.sub(/^\S*\s/,'')
  end

end
end
