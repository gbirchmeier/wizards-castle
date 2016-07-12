module TheWizardsCastle
class BattleRunner

  module Result
    RETREAT = :retreat,
    ENEMY_DEAD = :enemy_dead,
    PLAYER_DEAD = :player_dead
  end

  def initialize(player,enemy_symbol,printer,prompter)
    @player = player
    @enemy_symbol = enemy_symbol
    @printer = printer
    @prompter = prompter

    @enemy_power,@enemy_str = BattleRunner.enemy_stats(enemy_symbol)
    @bribable = true
  end

  def run
#    if enemy_first_shot?
#      bribable = false
#      do_enemy_attack(enemy_power)
#    end
#
#    loop do
#      @printer.youre_facing_a_monster
#      @printer.combat_menu(bribable)
#      @printer.your_battle_stats
#
#      allowed = ["A","R"]
#      allowed << "B" if bribable
#      allowed << "C" if (@player.int > 14) || bribable
#      # Yup, in both the Powers and Stetson versions,
#      #   you can cast whenever you can bribe,
#      #   even if your INT is under 14.
#
#      action = @prompter.ask_for_anything(@printer.prompt_combat)[0]
#      if allowed.include?(action)
#        case action
#        when "A"
#        when "R"
#        when "B"
#        when "C"
#        end
#
#        is enemy dead?
#
#        do_enemy_attack(enemy_power)
#      else
#        @printer.combat_selection_error_msg
#      end
#    end
  end

  def self.enemy_stats(sym)
    code = sym==:vendor ? 13 : Castle::MONSTERS.index(sym)+1
    return [ (1+(code/2)), code+2 ]
  end

#  def enemy_first_shot?
#    @player.lethargic? || @player.blind? || (@player.dex < (Random.rand(9)+Random.rand(9)+2))
#  end
#
#  def enemy_hit_player?
#    n = Random.rand(7)+Random.rand(7)+Random.rand(7)+3
#    n += 3 if @player.blind?
#    @player.dex < n
#  end
#
#  def player_hit_enemy?
#    n = Random.rand(20)+1
#    n += 3 if blind?
#    @player.dex >= n
#  end
#
#  def do_player_attack
#    if @player.weapon==:nothing
#      puts "** POUNDING ON ";C$(A+12);" WON'T HURT IT!"
#    elsif @player.bookstick
#      puts "** YOU CAN'T BEAT IT TO DEATH WITH A BOOK!"
#    else
#      if player_hit_enemy?
#        puts "YOU HIT THE EVIL ";Z$;"!"
#        enemy_str -= weapon_value
#
#        if [:gargoyle,:dragon].include?(enemy)
#          if Random.rand(8)==0 # 1/8 chance
#            puts "OH NO! YOUR ";W$(WV+1);" BROKE!"
#            @player.set_weapon(:nothing)
#          end
#        end
#      end
#    end
#  end
#
#  def do_enemy_attack(pow)
#    rc = @castle.room( *@player.location )
#    @printer.the_monster_attacks
#    if enemy_hit_player?
#      @player.take_a_hit(pow)
#      @printer.he_hit_you
#    else
#      @printer.he_missed_you
#    end
#  end

end
end
