module TheWizardsCastle
class StetsonPrinter

  def initialize(player)
    @player = player
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
OK, #{@player.race.to_s.upcase}, YOU HAVE THE FOLLOWING ATTRIBUTES :
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
      error: "** PLEASE ANSWER YES OR NO",
      success: "\n"
    }
  end


  def prompt_flares
    { prompt: "FLARES COST 1 GP EACH. HOW MANY DO YOU WANT? ",
      success: "\n",
      error: "\n** IF YOU DON'T WANT ANY, JUST TYPE 0 (ZERO).\n\n",
      out_of_range: "\n** YOU CAN ONLY AFFORD #{@player.gp} ."
    }
  end




#  def self.entering_the_castle(player)
#    "OK, #{player.race.to_s.upcase}, YOU ARE NOW ENTERING THE CASTLE!"
#  end
#
#  def self.you_are_here(player)
#    "YOU ARE AT ( #{player.location[0]} , #{player.location[1]} ) LEVEL #{player.location[2]} ."
#  end
#
#  def self.stat_block(player)
#    s = []
#    s << "STRENGTH = #{player.str}  INTELLIGENCE = #{player.int}  DEXTERITY = #{player.dex}"
#    s << "TREASURES = #{player.treasure_count}  FLARES = #{player.flares}  GOLD PIECES = #{player.gp}"
#    s << "WEAPON = #{player.weapon.to_s.upcase}  ARMOR = #{player.armor.to_s.upcase}"
#    s.last << "  AND A LAMP" if player.lamp?
#    s.join("\n")
#  end
#
#  def self.here_you_find(symbol)
#    "HERE YOU FIND #{RoomContent::ROOM_THINGS[symbol][:text]}."
#  end
#
#  def self.you_now_have(x)
#    "YOU NOW HAVE #{x}."
#  end
#
#  def self.standard_action_prompt
#    "ENTER YOUR COMMAND : "
#  end
#
#  def self.standard_action_error(player)
#    "** SILLY #{player.race.to_s.upcase}, THAT WASN'T A VALID COMMAND!"
#  end
#
#  def self.stairs_up_error
#    "** THERE ARE NO STAIRS GOING UP FROM HERE!"
#  end
#
#  def self.stairs_down_error
#    "** THERE ARE NO STAIRS GOING DOWN FROM HERE!"
#  end
#
#  def self.blind_command_error
#    "** YOU CAN'T SEE ANYTHING, YOU DUMB #{player.race.to_s.upcase}!"
#  end
#
#  def self.drink_error
#    "** IF YOU WANT A DRINK, FIND A POOL!"
#  end
#
#  def self.out_of_flares
#    "** HEY, BRIGHT ONE, YOU'RE OUT OF FLARES!"
#  end
#
#  def self.lamp_prompt
#    "WHERE DO YOU WANT TO SHINE THE LAMP (N,S,E,W)? "
#  end
#
#  def self.no_lamp_error(player)
#    "** YOU DON'T HAVE A LAMP, #{player.race.to_s.upcase}!"
#  end
#
#  def self.lamp_prompt_error(player)
#    "** THAT'S NOT A DIRECTION, #{player.race.to_s.upcase}!"
#  end
#
#  def self.lamp_shine(row,col,floor,room_content)
#    s =<<END_SHINE
#THE LAMP SHINES INTO ( #{row} , #{col} ) LEVEL #{floor} .
#
#THERE YOU WILL FIND #{room_content.text}.
#END_SHINE
#    s
#  end
#
#  def self.no_crystal_orb_error
#    "** IT'S HARD TO GAZE WITHOUT AN ORB!"
#  end
#
#  def self.help(player)
#    s=<<END_HELP
#*** WIZARD'S CASTLE COMMAND AND INFORMATION SUMMARY ***
#
#THE FOLLOWING COMMANDS ARE AVAILABLE :
#
#H/ELP     N/ORTH    S/OUTH    E/AST     W/EST     U/P
#D/OWN     DR/INK    M/AP      F/LARE    L/AMP     O/PEN
#G/AZE     T/ELEPORT Q/UIT
#
#THE CONTENTS OF ROOMS ARE AS FOLLOWS :
#
#. = EMPTY ROOM      B = BOOK            C = CHEST
#D = STAIRS DOWN     E = ENTRANCE/EXIT   F = FLARES
#G = GOLD PIECES     M = MONSTER         O = CRYSTAL ORB
#P = MAGIC POOL      S = SINKHOLE        T = TREASURE
#U = STAIRS UP       V = VENDOR          W = WARP/ORB
#
#THE BENEFITS OF HAVING TREASURES ARE :
#
#RUBY RED - AVOID LETHARGY     PALE PEARL - AVOID LEECH
#GREEN GEM - AVOID FORGETTING  OPAL EYE - CURES BLINDNESS
#BLUE FLAME - DISSOLVES BOOKS  NORN STONE - NO BENEFIT
#PALANTIR - NO BENEFIT         SILMARIL - NO BENEFIT
#
#PRESS RETURN WHEN READY TO RESUME, #{player.race.to_s.upcase}.
#END_HELP
#    s.chomp
#  end
#
#
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

  def random_monster_text
    RoomContent::ROOM_THINGS[Castle::MONSTERS.sample][:text]
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
