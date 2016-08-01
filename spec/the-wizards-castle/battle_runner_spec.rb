module TheWizardsCastle
describe BattleRunner do

  class BattleRunner
    attr_accessor :enemy_power,:enemy_str, :web_counter
  end


  it "::enemy_stats" do
    expect(BattleRunner.enemy_stats(:kobold)).to eq   [1,3]  # pow, str
    expect(BattleRunner.enemy_stats(:orc)).to eq      [2,4]
    expect(BattleRunner.enemy_stats(:wolf)).to eq     [2,5]
    expect(BattleRunner.enemy_stats(:goblin)).to eq   [3,6]
    expect(BattleRunner.enemy_stats(:ogre)).to eq     [3,7]
    expect(BattleRunner.enemy_stats(:troll)).to eq    [4,8]
    expect(BattleRunner.enemy_stats(:bear)).to eq     [4,9]
    expect(BattleRunner.enemy_stats(:minotaur)).to eq [5,10]
    expect(BattleRunner.enemy_stats(:gargoyle)).to eq [5,11]
    expect(BattleRunner.enemy_stats(:chimera)).to eq  [6,12]
    expect(BattleRunner.enemy_stats(:balrog)).to eq   [6,13]
    expect(BattleRunner.enemy_stats(:dragon)).to eq   [7,14]
    expect(BattleRunner.enemy_stats(:vendor)).to eq   [7,15]
  end

  context "#run" do
    before(:each) do
      @prompter = TestPrompter.new
      @player = Player.new
      @player.str(+5)
      @player.int(+18)
      @player.dex(+8)
      @brunner = BattleRunner.new(@player,:dragon,NullPrinter.new,@prompter)
    end

    it "killed by enemy's pre-emptive attack" do
      allow(@brunner).to receive(:enemy_first_shot?).and_return true
      allow(@brunner).to receive(:enemy_hit_player?).and_return true
      expect(@brunner.run).to eq BattleRunner::Result::PLAYER_DEAD
    end

    context "attack:" do
      before(:each) do
        allow(@brunner).to receive(:enemy_first_shot?).and_return false
        @prompter.push "A"
      end

      it "killed monster" do
        allow(@brunner).to receive(:do_player_attack).and_return nil
        expect(@brunner).not_to receive(:do_enemy_attack)
        @brunner.enemy_str = 0
        expect(@brunner.run).to eq BattleRunner::Result::ENEMY_DEAD
      end

      it "got killed" do
        allow(@brunner).to receive(:do_player_attack).and_return nil
        expect(@brunner).to receive(:do_enemy_attack).and_return nil
        @player.str(-20)
        expect(@brunner.run).to eq BattleRunner::Result::PLAYER_DEAD
      end
    end

    context "retreat (and implicitly, #do_enemy_attack)" do
      before(:each) do
        allow(@brunner).to receive(:enemy_first_shot?).and_return false
        @prompter.push "R"
      end

      context "and get hit and" do
        before(:each) do
          allow(@brunner).to receive(:enemy_hit_player?).and_return true
        end

        it "die" do
          expect(@brunner.run).to eq BattleRunner::Result::PLAYER_DEAD
          expect(@player.str).to eq 0
        end
        it "survive" do
          @brunner.enemy_power = 1
          expect(@brunner.run).to eq BattleRunner::Result::RETREAT
          expect(@player.str).to eq 4
        end
      end

      it "without getting hit" do
        allow(@brunner).to receive(:enemy_hit_player?).and_return false
        expect(@brunner.run).to eq BattleRunner::Result::RETREAT
        expect(@player.str).to eq 5
      end
    end

    context "bribe" do
      before(:each) do
        allow(@brunner).to receive(:enemy_first_shot?).and_return false
        @prompter.push "B"
      end

      it "accepted" do
        allow(@brunner).to receive(:do_bribe?).and_return true
        expect(@brunner).not_to receive(:do_enemy_attack)
        expect(@brunner.run).to eq BattleRunner::Result::BRIBED
      end

      it "refused and killed" do
        @player.str(-20)
        allow(@brunner).to receive(:do_bribe?).and_return false
        allow(@brunner).to receive(:do_enemy_attack).and_return nil
        expect(@brunner.run).to eq BattleRunner::Result::PLAYER_DEAD
      end
    end
  end #run

  context "#do_player_attack" do
    before(:each) do
      @player = Player.new
      @player.str(+5)
      @player.int(+8)
      @player.dex(+8)
      @printer = NullPrinter.new
      @brunner = BattleRunner.new(@player,:dragon,@printer,TestPrompter.new)
    end

    it "without weapon" do
      @player.set_weapon(:nothing)
      expect(@printer).to receive(:unarmed_attack)
      @brunner.do_player_attack
      expect(@brunner.enemy_str).to eq 14 #unharmed
    end
    it "with book stuck to hands" do
      @player.set_weapon(:sword)
      @player.set_stickybook(true)
      expect(@printer).to receive(:book_attack)
      @brunner.do_player_attack
      expect(@brunner.enemy_str).to eq 14 #unharmed
    end

    context "hit" do
      before(:each) do
        @player.set_weapon(:sword)
        allow(@brunner).to receive(:player_hit_enemy?).and_return true
      end
      after(:each) do
        @brunner.do_player_attack
        expect(@brunner.enemy_str).to eq 11
      end

      it "and weapon stays intact" do
        allow(@brunner).to receive(:broken_weapon?).and_return false
      end
      it "and weapon breaks" do
        allow(@brunner).to receive(:broken_weapon?).and_return true
        expect(@printer).to receive(:your_weapon_broke)
      end
    end

    it "miss" do
      allow(@brunner).to receive(:player_hit_enemy?).and_return false
      expect(@brunner).not_to receive(:broken_weapon?)
      @brunner.do_player_attack
      expect(@brunner.enemy_str).to eq 14 #unharmed
    end
  end # do_player_attack


  context "#do_bribe?" do
    before(:each) do
      @prompter = TestPrompter.new
      @player = Player.new
      @player.str(+5)
      @player.int(+8)
      @player.dex(+8)
      @printer = NullPrinter.new
      @brunner = BattleRunner.new(@player,:dragon,@printer,@prompter)
    end

    context "false:" do
      it "player has no treasure" do
        expect(@printer).to receive(:bribe_refused)
        expect(@brunner.do_bribe?).to eq false
      end
      it "player refuses offer" do
        @player.add_treasure(:opal_eye)
        @prompter.push "N"
        expect(@brunner.do_bribe?).to eq false
        expect(@player.have_treasure?(:opal_eye)).to eq true
      end
    end

    it "true" do
      @player.add_treasure(:opal_eye)
      @prompter.push "Y"
      expect(@printer).to receive(:bribe_accepted)
      expect(@brunner.do_bribe?).to eq true
      expect(@player.have_treasure?(:opal_eye)).to eq false
    end
  end

  context "#do_cast" do
    before(:each) do
      @prompter = TestPrompter.new
      @player = Player.new
      @player.str(+18)
      @player.int(+18)
      @player.dex(+18)
      @printer = NullPrinter.new
      @brunner = BattleRunner.new(@player,:dragon,@printer,@prompter)
    end

    it "web" do
      @prompter.push "W"
      allow(@brunner).to receive(:random_web_duration).and_return 5
      @brunner.do_cast
      expect(@brunner.web_counter).to eq 5
      expect(@player.str).to eq 17
      expect(@player.int).to eq 18
      expect(@brunner.enemy_str).to eq 14 #unharmed
    end

    it "fireball" do
      @prompter.push "F"
      allow(@brunner).to receive(:random_fireball_damage).and_return 10
      @brunner.do_cast
      expect(@player.str).to eq 17
      expect(@player.int).to eq 17
      expect(@brunner.enemy_str).to eq 4
    end

    context "deathspell" do
      it "kills monster" do
        @prompter.push "D"
        allow(@brunner).to receive(:deathspell_kills_player?).and_return false
        @brunner.do_cast
        expect(@player.str).to eq 18
        expect(@player.int).to eq 18
        expect(@brunner.enemy_str).to eq 0
      end
      it "kills player" do
        @prompter.push "D"
        allow(@brunner).to receive(:deathspell_kills_player?).and_return true
        @brunner.do_cast
        expect(@player.str).to eq 18
        expect(@player.int).to eq 0
        expect(@brunner.enemy_str).to eq 14
      end
    end
  end #do_cast

  context "web effect" do
    before(:each) do
      @prompter = TestPrompter.new
      @player = Player.new
      @player.str(+18)
      @player.int(+18)
      @player.dex(+18)
      @printer = NullPrinter.new
      @brunner = BattleRunner.new(@player,:dragon,@printer,@prompter)
    end

    it "no web" do
      @brunner.web_counter = 0
      expect(@printer).not_to receive(:the_web_broke)
      expect(@printer).not_to receive(:monster_stuck_in_web)
      expect(@printer).to receive(:the_monster_attacks)
      @brunner.do_enemy_attack
      expect(@brunner.web_counter).to eq 0
    end

    it "enemy stuck" do
      @brunner.web_counter = 2
      expect(@printer).not_to receive(:the_web_broke)
      expect(@printer).to receive(:monster_stuck_in_web)
      expect(@printer).not_to receive(:the_monster_attacks)
      @brunner.do_enemy_attack
      expect(@brunner.web_counter).to eq 1
    end

    it "enemy freed" do
      @brunner.web_counter = 1
      expect(@printer).to receive(:the_web_broke)
      expect(@printer).not_to receive(:monster_stuck_in_web)
      expect(@printer).to receive(:the_monster_attacks)
      @brunner.do_enemy_attack
      expect(@brunner.web_counter).to eq 0
    end
  end

end
end
