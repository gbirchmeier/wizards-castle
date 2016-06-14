module TheWizardsCastle
describe Runner do
context "#player_action" do

  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
  end

  context("basic movement:") do
    before(:each) do
      @runner.castle.set_in_room(2,2,2,:empty_room)
      @runner.castle.set_in_room(1,2,2,:empty_room)
      @runner.castle.set_in_room(3,2,2,:empty_room)
      @runner.castle.set_in_room(2,1,2,:empty_room)
      @runner.castle.set_in_room(2,3,2,:empty_room)
      @runner.player.set_location(2,2,2)
    end

    it "N" do
      @prompter.push("N")
      expect(@runner.player_action).to eq Runner::PlayerStatus::NEW_ROOM
      expect(@runner.player.location).to eq [1,2,2]
      expect(@runner.player.facing).to eq :n
    end
    it "S" do
      @prompter.push("S")
      expect(@runner.player_action).to eq Runner::PlayerStatus::NEW_ROOM
      expect(@runner.player.location).to eq [3,2,2]
      expect(@runner.player.facing).to eq :s
    end
    it "W" do
      @prompter.push("W")
      expect(@runner.player_action).to eq Runner::PlayerStatus::NEW_ROOM
      expect(@runner.player.location).to eq [2,1,2]
      expect(@runner.player.facing).to eq :w
    end
    it "E" do
      @prompter.push("E")
      expect(@runner.player_action).to eq Runner::PlayerStatus::NEW_ROOM
      expect(@runner.player.location).to eq [2,3,2]
      expect(@runner.player.facing).to eq :e
    end
  end

  context("entrance move:") do
    before(:each) do
      @runner.castle.set_in_room(2,2,2,:entrance)
      @runner.castle.set_in_room(2,1,2,:empty_room)
      @runner.player.set_location(2,2,2)
    end

    it "N" do
      @prompter.push "N"
      expect(@runner.player_action).to eq Runner::PlayerStatus::EXITED
    end

    it "W" do
      @prompter.push "W"
      expect(@runner.player_action).to eq Runner::PlayerStatus::NEW_ROOM
      expect(@runner.player.facing).to eq :w
    end
  end

end
end
end
