module TheWizardsCastle
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

  it "player died" do
    allow(@runner).to receive(:run_battle).and_return BattleRunner::Result::PLAYER_DEAD
    expect(@runner.combat).to eq Runner::PlayerState::DIED
  end

end
end
end
