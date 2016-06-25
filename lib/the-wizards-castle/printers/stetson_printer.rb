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
    # TODO pause here
  end

  def character_creation_header
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
  end


  def prompt_standard_action
    { prompt:  "ENTER YOUR COMMAND : ",
      error:   "\n** SILLY #{player_race}, THAT WASN'T A VALID COMMAND!\n\n",
      success: "\n"  #TODO prevent newline if flare action, add newline if teleport action
    }
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

#  def self.blind_command_error
#    "** YOU CAN'T SEE ANYTHING, YOU DUMB #{player.race.to_s.upcase}!"
#  end

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

  def drink_error
# TODO rename this to no_pool_error
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


#----------------------
# teleport into zot space

#Z-COORDINATE? 8                                                                 
#                                                                                
#YOU ARE AT ( 8 , 8 ) LEVEL 8 .                                                  
#                                                                                
#STRENGTH = 8  INTELLIGENCE = 8  DEXTERITY = 16                                  
#TREASURES = 0  FLARES = 7  GOLD PIECES = 0                                      
#WEAPON = SWORD  ARMOR = NO ARMOR  AND A LAMPORBOFZOT: 8 - 8 - 8                 
#                                                                                
#                                                                                
#HERE YOU FIND A WARP.                                                           
#                                                                                
#GREAT UNMITIGATED ZOT!                                                          
#                                                                                
#YOU JUST FOUND ***THE ORB OF ZOT***!                                            
#                                                                                
#THE RUNESTAFF HAS DISAPPEARED!                                                  
#                                                                                
#ENTER YOUR COMMAND :                 
# map is now a dot


  def prompt_confirm_quit
    { prompt: "DO YOU REALLY WANT TO QUIT NOW? ",
      confirmed: "\n\n\n",
      denied: "\n** THEN DON'T SAY THAT YOU DO!\n\n",
    }
  end

#
##YOU TAKE A DRINK AND FEEL DUMBER.
##
##****************************************************************
##
##A NOBLE EFFORT, OH FORMERLY LIVING HUMAN!
##
##YOU DIED DUE TO LACK OF INTELLIGENCE.
##
##AT THE TIME YOU DIED, YOU HAD :
##THE OPAL EYE
##THE SILMARIL
##DAGGER AND PLATE AND A LAMP
##YOU ALSO HAD 0 FLARES AND 5 GOLD PIECES
##
##AND IT TOOK YOU 42 TURNS!
##
##ARE YOU FOOLISH ENOUGH TO WANT TO PLAY AGAIN?
#
#
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

end
end
