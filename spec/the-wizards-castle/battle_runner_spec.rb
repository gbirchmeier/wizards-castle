module TheWizardsCastle
describe BattleRunner do

  class BattleRunner
    attr_accessor :enemy_power
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

  context "retreat" do
    before(:each) do
      @prompter = TestPrompter.new
      @player = Player.new
      @player.str(+5)
      @player.int(+8)
      @player.dex(+8)
      @brunner = BattleRunner.new(@player,:dragon,NullPrinter.new,@prompter)

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

end
end
