module TheWizardsCastle
module Strings

  INTRO =<<END_INTRO
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
# Intro followed by pause

  CHARACTER_CREATION_HEADER = "ALL RIGHT, BOLD ONE."

  RACE_PROMPT = "YOU MAY BE AN ELF, DWARF, MAN, OR HOBBIT.\n\nYOUR CHOICE? "
  RACE_ERROR = "** THAT WAS INCORRECT. PLEASE TYPE E, D, M, OR H."

  GENDER_PROMPT = "WHICH SEX TO YOU PREFER? "
  def self.gender_error(player)
    "** CUTE #{player.race.to_s.upcase}, REAL CUTE. TRY M OR F."
  end

  def self.attributes_prompt_header(player,other_points)
    s =<<END_ATT_PROMPT_INTRO
OK, #{player.race.to_s.upcase}, YOU HAVE THE FOLLOWING ATTRIBUTES :
STRENGTH = #{player.str}  INTELLIGENCE = #{player.int}  DEXTERITY = #{player.dex}
AND #{other_points} OTHER POINTS TO ALLOCATE AS YOU WISH.
END_ATT_PROMPT_INTRO
  end

  STRENGTH_PROMPT = "HOW MANY POINTS DO YOU WISH TO ADD TO YOUR STRENGTH? "
  INTELLIGENCE_PROMPT = "HOW MANY POINTS DO YOU WISH TO ADD TO YOUR INTELLIGENCE? "
  DEXTERITY_PROMPT = "HOW MANY POINTS DO YOU WISH TO ADD TO YOUR DEXTERITY? "

  def self.gold_report1(player)
    "OK, #{player.race.to_s.upcase}, YOU HAVE #{player.gp} GOLD PIECES (GP'S)."
  end

  def self.gold_report2(player)
    "OK, BOLD #{player.race.to_s.upcase}, YOU HAVE #{player.gp} GP'S LEFT."
  end

  def self.gold_report3(player)
    "OK, #{player.race.to_s.upcase}, YOU HAVE #{player.gp} GOLD PIECES LEFT."
  end

  def self.armor_prompt
    s =<<END_ARMOR_PROMPT
THESE ARE THE TYPES OF ARMOR YOU CAN BUY :
PLATE<30> CHAINMAIL<20> LEATHER<10> NOTHING<0>

YOUR CHOICE? 
END_ARMOR_PROMPT
    s.chomp
  end

  def self.armor_error(player)
    monster = Castle::MONSTERS.sample.to_s.upcase
    article = ["A","E","I","O","U"].include?(monster[0]) ? "AN" : "A"
    "** ARE YOU A #{player.race.to_s.upcase} OR #{article} #{monster}?"
  end

  def self.weapon_prompt
    s =<<END_WEAPON_PROMPT
THESE ARE THE TYPES OF WEAPONS YOU CAN BUY :
SWORD<30> MACE<20> DAGGER<10> NOTHING<0>

YOUR CHOICE? 
END_WEAPON_PROMPT
    s.chomp
  end

  def self.weapon_error(player)
    "** IS YOUR IQ REALLY #{player.int} ?"
  end

  LAMP_PROMPT = "DO YOU WANT TO BUY A LAMP FOR 20 GP'S? "
  YESNO_ERROR = "** PLEASE ANSWER YES OR NO"
  FLARE_PROMPT = "FLARES COST 1 GP EACH. HOW MANY DO YOU WANT? "
  FLARE_ERROR = "** IF YOU DON'T WANT ANY, JUST TYPE 0 (ZERO)."
  def self.flare_afford(player)
    "** YOU CAN ONLY AFFORD #{player.gp} ."
  end


  def self.entering_the_castle(player)
    "OK, #{player.race.to_s.upcase}, YOU ARE NOW ENTERING THE CASTLE!"
  end

  def self.you_are_here(player)
    "YOU ARE AT ( #{player.location[0]} , #{player.location[1]} ) LEVEL #{player.location[2]} ."
  end


#OK, HOBBIT, YOU ARE NOW ENTERING THE CASTLE!                                    
#                                                                                
#YOU ARE AT ( 1 , 4 ) LEVEL 1 .                                                  
#                                                                                
#STRENGTH = 6  INTELLIGENCE = 10  DEXTERITY = 12                                 
#TREASURES = 0  FLARES = 0  GOLD PIECES = 30                                     
#WEAPON = DAGGER  ARMOR = CHAINMAIL                                              
#                                                                                
#HERE YOU FIND THE ENTRANCE.                                                     
#                                                                                
#ENTER YOUR COMMAND :    


end
end
