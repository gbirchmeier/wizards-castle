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

  context "enter_room triggers:" do
    it "ignore him" do
      @prompter.push "I"
      expect(@runner.enter_room).to eq Runner::PlayerState::ACTION
    end

    it "get attacked (and run away)" do
      @runner.player.set_vendor_rage(true)
      allow(@runner).to receive(:combat).and_return Runner::PlayerState::NEW_ROOM
      expect(@runner.enter_room).to eq Runner::PlayerState::NEW_ROOM
    end

    it "attack (and get killed)" do
      @prompter.push "A"
      expect(@runner.printer).to receive :vendor_responds_to_attack
      allow(@runner).to receive(:combat).and_return Runner::PlayerState::DIED
      expect(@runner.enter_room).to eq Runner::PlayerState::DIED
      expect(@runner.player.vendor_rage?).to eq true
    end
  end

  context "combat scenarios:" do
#    it "attack and kill him and get his loot" do
#      @prompter.push "A"
#      allow(@runner).to receive(:combat).and_return 
#    end

#    it "get attacked and bribe him happy" do  #TODO
#    end
  end

end
end
end
