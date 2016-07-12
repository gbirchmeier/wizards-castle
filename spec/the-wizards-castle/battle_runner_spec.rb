module TheWizardsCastle
describe BattleRunner do

  it "::enemy_stats" do
    expect(BattleRunner.enemy_stats(:kobold)).to eq   [1,3]
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

end
end
