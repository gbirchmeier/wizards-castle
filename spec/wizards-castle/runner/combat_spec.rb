module WizardsCastle
describe Runner do
context "combat:" do

  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)

    @runner.castle.set_in_room(2,2,2,:kobold)
    @runner.player.set_location(2,2,2)
  end

  it "retreated" do
    @prompter.push "W"
    allow(@runner).to receive(:run_battle).and_return BattleRunner::Result::RETREAT
    expect(@runner.combat).to eq Runner::PlayerState::NEW_ROOM
    expect(@runner.player.location).to eq [2,1,2]
    expect(@runner.player.facing).to eq :w
    expect(@runner.castle.room(2,2,2).symbol).to eq :kobold
  end

  it "bribed" do
    allow(@runner).to receive(:run_battle).and_return BattleRunner::Result::BRIBED
    expect(@runner.combat).to eq Runner::PlayerState::ACTION
    # make sure player is not bothered by monster on next action
    @prompter.push("H")
    expect(@runner.printer).to receive(:help_message)
    expect(@runner.player_action).to eq Runner::PlayerState::ACTION
  end

  it "player died" do
    allow(@runner).to receive(:run_battle).and_return BattleRunner::Result::PLAYER_DEAD
    expect(@runner.combat).to eq Runner::PlayerState::DIED
  end

  context "enemy killed" do
    before(:each) do
      @runner.player.set_location(2,2,2)
      allow(@runner).to receive(:run_battle).and_return BattleRunner::Result::ENEMY_DEAD
      allow(@runner).to receive(:monster_random_gp).and_return 500
      expect(@runner.printer).to receive(:monster_is_dead)
    end
    after(:each) do
      expect(@runner.player.gp).to eq 560
      expect(@runner.castle.room(2,2,2).symbol).to eq :empty_room
    end

    it "has just gold" do
      @runner.castle.set_in_room(2,2,2,:kobold)
      expect(@runner.combat).to eq Runner::PlayerState::ACTION
      expect(@runner.player.runestaff?).to eq false
    end

    it "has runestaff" do
      @runner.castle.set_in_room(2,2,2,:runestaff_and_monster)
      expect(@runner.combat).to eq Runner::PlayerState::ACTION
      expect(@runner.player.runestaff?).to eq true
    end
  end

  context "#eat_monster_maybe" do
    class Player
      attr_accessor :last_ate_turn
    end

    context "initial meal" do
      before(:each) do
        expect(@runner.player.turns).to eq 1
      end
      it "no" do
        @runner.player.turns(+58) #turn 59
        expect(@runner.printer).not_to receive :eat_a_monster
        @runner.eat_monster_maybe
        expect(@runner.player.last_ate_turn).to eq 0
      end
      it "yes" do
        @runner.player.turns(+59) #turn 60
        expect(@runner.printer).to receive :eat_a_monster
        @runner.eat_monster_maybe
        expect(@runner.player.last_ate_turn).to eq 60
      end
    end

    context "later meal" do
      before(:each) do
        @runner.player.last_ate_turn = 100
        expect(@runner.player.turns).to eq 1
      end
      it "no" do
        @runner.player.turns(+158) #turn 159
        expect(@runner.printer).not_to receive :eat_a_monster
        @runner.eat_monster_maybe
        expect(@runner.player.last_ate_turn).to eq 100
      end
      it "yes" do
        @runner.player.turns(+159) #turn 160
        expect(@runner.printer).to receive :eat_a_monster
        @runner.eat_monster_maybe
        expect(@runner.player.last_ate_turn).to eq 160
      end
    end
  end

end
end
end
