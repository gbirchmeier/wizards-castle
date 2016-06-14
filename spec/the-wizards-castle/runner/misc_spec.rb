module TheWizardsCastle
describe Runner do
context "misc" do

  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
  end

  context "turn counter" do
    it "is 1 before the first move" do
      @runner.enter_room
      expect(@runner.player.turns).to eq 1
    end

    it "is 2 after the first move" do
      expect(@runner.player.location).to eq [1,4,1]
      @runner.castle.set_in_room(1,5,1,:empty_room)
      @prompter.push("S")
      expect(@runner.enter_room).to eq Runner::PlayerStatus::ACTION
      expect(@runner.player_action).to eq Runner::PlayerStatus::NEW_ROOM
      expect(@runner.player.turns).to eq 2
    end
  end

end
end
end
