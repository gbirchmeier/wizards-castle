module TheWizardsCastle
describe Runner do
context "encounter a vendor and" do

  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
    @runner.castle.set_in_room(2,2,2,:vendor)
    @runner.player.set_location(2,2,2)
  end

  it "ignore him" do
    @prompter.push "I"
    expect(@runner.enter_room).to eq Runner::PlayerState::ACTION
  end

end
end
end
