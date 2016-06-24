module TheWizardsCastle
describe Runner do
context "afflictions" do

  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
  end 

  context "turn-start curses" do
    before(:each) do
      @runner.player.set_location(2,2,2)
      @runner.castle.set_in_room(2,2,2,:empty_room)
      @prompter.push "H"  #doesn't matter what this is
      expect(@runner.player.turns).to eq 1
      expect(@runner.player.gp).to eq 60
    end

    context "lethargy" do
      before(:each) do
        @runner.player.set_lethargic(true)
      end
      it "succumb" do
        @runner.player_action
        expect(@runner.player.turns).to eq 3
      end
      context "avoid" do
        after(:each) do
          @runner.player_action
          expect(@runner.player.turns).to eq 2
        end
        it "with ruby_red" do
          @runner.player.add_treasure(:ruby_red)
        end
        it "with runestaff" do
          @runner.player.set_runestaff(true)
        end
        it "with orb_of_zot" do
          @runner.player.set_orb_of_zot(true)
        end
      end
    end 

    context "leech" do
      before(:each) do
        @runner.player.set_leech(true)
      end
      it "succumb" do
        allow(@runner).to receive(:leech_gp_loss).and_return 4
        @runner.player_action
        expect(@runner.player.gp).to eq 56
      end
      context "avoid" do
        after(:each) do
          @runner.player_action
          expect(@runner.player.gp).to eq 60
        end
        it "with pale_pearl" do
          @runner.player.add_treasure(:pale_pearl)
        end
        it "with runestaff" do
          @runner.player.set_runestaff(true)
        end
        it "with orb_of_zot" do
          @runner.player.set_orb_of_zot(true)
        end
      end
    end 

    context "forgetful" do
      before(:each) do
        @runner.player.set_forgetful(true)
      end
      it "succumb" do
        expect(@runner.player).to receive(:forget_random_room)
        @runner.player_action
      end
      context "avoid" do
        after(:each) do
        expect(@runner.player).not_to receive(:forget_random_room)
          @runner.player_action
        end
        it "with green_gem" do
          @runner.player.add_treasure(:green_gem)
        end
        it "with runestaff" do
          @runner.player.set_runestaff(true)
        end
        it "with orb_of_zot" do
          @runner.player.set_orb_of_zot(true)
        end
      end

    end 
  end

end
end
end
