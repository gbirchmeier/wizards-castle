module TheWizardsCastle
class BattleRunner

  module Result
    RETREAT = :retreat
    BRIBED = :bribed
    ENEMY_DEAD = :enemy_dead
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
    if enemy_first_shot?
      @bribable = false
      do_enemy_attack(enemy_power)
    end

    loop do
      @printer.youre_facing_a_monster
      @printer.combat_menu(@bribable)
      @printer.your_battle_stats

      allowed = ["A","R"]
      allowed << "B" if @bribable
      allowed << "C" if (@player.int > 14) || @bribable
      # Yup, in both the Powers and Stetson versions,
      #   you can cast whenever you can bribe,
      #   even if your INT is under 14.
      #   You can die if this cast drops your INT to 0.

      action = @prompter.ask_for_anything(@printer.prompt_combat)[0]
      if allowed.include?(action)
        case action
        when "A"
          do_player_attack
          return Result::ENEMY_DEAD if @enemy_str<1
          do_enemy_attack
          return Result::PLAYER_DEAD if @player.dead?
        when "R" #retreat
          do_enemy_attack
          return @player.dead? ? Result::PLAYER_DEAD : Result::RETREAT
        when "B"
          return Result::BRIBED if do_bribe?
          do_enemy_attack
          return Result::PLAYER_DEAD if @player.dead?
        when "C"
          raise "TODO cast not impld"
        end

        @bribeable = false

      else
        @printer.combat_selection_error_msg
      end
    end
  end

  def self.enemy_stats(sym)
    code = sym==:vendor ? 13 : Castle::MONSTERS.index(sym)+1
    return [ (1+(code/2)), code+2 ]
  end

  def enemy_first_shot?
    @player.lethargic? || @player.blind? || (@player.dex < (Random.rand(9)+Random.rand(9)+2))
  end

  def enemy_hit_player?
    n = Random.rand(7)+Random.rand(7)+Random.rand(7)+3
    n += 3 if @player.blind?
    @player.dex < n
  end

  def do_enemy_attack
    @printer.the_monster_attacks
    if enemy_hit_player?
      @player.take_a_hit(@enemy_power,@printer)
      @printer.he_hit_you
    else
      @printer.he_missed_you
    end
  end

  def player_hit_enemy?
    n = Random.rand(20)+1
    n += 3 if blind?
    @player.dex >= n
  end

  def do_player_attack
    if @player.weapon==:nothing
      @printer.unarmed_attack
    elsif @player.stickybook?
      @printer.book_attack
    else
      if player_hit_enemy?
        @printer.you_hit_him
        @enemy_str -= @player.weapon_value

        if [:gargoyle,:dragon].include?(@enemy_symbol)
          if broken_weapon?
            @printer.your_weapon_broke
            @player.set_weapon(:nothing)
          end
        end
      end
    end
  end

  def broken_weapon?
    Random.rand(8)==0 # 1/8 chance
  end


  def do_bribe?
    if @player.treasure_count < 1
      @printer.bribe_refused
    else
      desired_treasure = @player.random_treasure
      answer = @prompter.ask(['Y','N'],@printer.prompt_bribe_request(desired_treasure))
      if answer=='Y'
        @printer.bribe_accepted
        return true
      end
    end
    false
  end

end
end
