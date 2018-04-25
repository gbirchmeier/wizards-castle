module WizardsCastle
  class ShoppingTrip

    def initialize(player,printer,prompter)
      @player = player
      @printer = printer
      @prompter = prompter
    end

    def run()
      sell_treasures
      if @player.gp < 1000
        @printer.too_poor_to_trade
        return
      end
      buy_armor
      buy_weapon
      buy_str_potions
      buy_int_potions
      buy_dex_potions
      buy_lamp
    end

    def random_treasure_offer(i)
      Random.rand((i+1)*1500) + 1
    end

    def sell_treasures
      a = %i[ruby_red norn_stone pale_pearl opal_eye green_gem blue_flame palantir silmaril]
      a.each_with_index do |treasure,i|
        if @player.have_treasure?(treasure)
          offer = random_treasure_offer(i)
          answer = @prompter.ask(['Y', 'N'], @printer.prompt_sell_treasure(treasure, offer))
          if answer == 'Y'
            @player.remove_treasure(treasure)
            @player.gp(+offer)
          end
        end
      end
    end

    def buy_armor
      return if @player.gp < 1250
      @printer.gold_and_armor_report
      @printer.vendor_armors

      loop do
        answer = @prompter.ask(%w[N L C P], @printer.prompt_vendor_armor)
        case answer
        when 'N'
          return
        when 'L'
          @player.gp(-1250)
          @player.set_armor(:leather)
          return
        when 'C'
          if @player.gp < 1500
            @printer.cannot_afford_chainmail
          else
            @player.gp(-1500)
            @player.set_armor(:chainmail)
            return
          end
        when 'P'
          if @player.gp < 2000
            @printer.cannot_afford_plate
          else
            @player.gp(-2000)
            @player.set_armor(:plate)
            return
          end
        end
      end
    end

    def buy_weapon
      return if @player.gp < 1250
      @printer.gold_and_weapon_report
      @printer.vendor_weapons

      loop do
        answer = @prompter.ask(%w[N D M S],@printer.prompt_vendor_weapon)
        case answer
        when 'N'
          return
        when 'D'
          @player.gp(-1250)
          @player.set_weapon(:dagger)
          return
        when 'M'
          if @player.gp < 1500
            @printer.cannot_afford_a_mace
          else
            @player.gp(-1500)
            @player.set_weapon(:mace)
            return
          end
        when 'S'
          if @player.gp < 2000
            @printer.cannot_afford_a_sword
          else
            @player.gp(-2000)
            @player.set_weapon(:sword)
            return
          end
        end
      end
    end

    def random_stat_gain
      Random.rand(6)+1
    end

    def buy_str_potions
      loop do
        return if @player.gp < 1000
        answer = @prompter.ask(['Y', 'N'],@printer.prompt_vendor_str_potion)
        if answer == 'Y'
          @player.gp(-1000)
          @player.str(+random_stat_gain)
          @printer.str_report
        else
          return
        end
      end
    end

    def buy_int_potions
      loop do
        return if @player.gp < 1000
        answer = @prompter.ask(['Y', 'N'],@printer.prompt_vendor_int_potion)
        if answer == 'Y'
          @player.gp(-1000)
          @player.int(+random_stat_gain)
          @printer.int_report
        else
          return
        end
      end
    end

    def buy_dex_potions
      loop do
        return if @player.gp < 1000
        answer = @prompter.ask(['Y', 'N'],@printer.prompt_vendor_dex_potion)
        if answer == 'Y'
          @player.gp(-1000)
          @player.dex(+random_stat_gain)
          @printer.dex_report
        else
          return
        end
      end
    end

    def buy_lamp
      return if (@player.gp < 1000 || @player.lamp?)
      answer = @prompter.ask(['Y', 'N'],@printer.prompt_vendor_buy_lamp)
      if answer == 'Y'
        @player.gp(-1000)
        @player.set_lamp(true)
        @printer.you_bought_a_lamp
      end
    end

  end
end
