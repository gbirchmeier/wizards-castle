module TheWizardsCastle
describe Runner do
context "#enter_room" do

  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
  end

  it "gold" do
    old_gold_count = @runner.player.gp
    @runner.castle.set_in_room(2,2,2,:gold)
    @runner.player.set_location(2,2,2)
    expect(@runner.enter_room).to eq Runner::PlayerStatus::PLAYING
    expect(@runner.player.gp).to be > old_gold_count
  end

  it "flares" do
    old_flare_count = @runner.player.flares
    @runner.castle.set_in_room(2,2,2,:flares)
    @runner.player.set_location(2,2,2)
    expect(@runner.enter_room).to eq Runner::PlayerStatus::PLAYING
    expect(@runner.player.flares).to be > old_flare_count
  end

  it "warp" do
    @runner.castle.set_in_room(2,2,2,:warp)
    @runner.player.set_location(2,2,2)
    allow(Castle).to receive(:random_room).and_return([5,5,5])
    expect(@runner.enter_room).to eq Runner::PlayerStatus::PLAYING
    expect(@runner.player.location).to eq [5,5,5]
  end

  it "sinkhole" do
    @runner.castle.set_in_room(2,2,2,:sinkhole)
    @runner.player.set_location(2,2,2)
    expect(@runner.enter_room).to eq Runner::PlayerStatus::PLAYING
    expect(@runner.player.location).to eq [2,2,3]
  end


end
end
end
