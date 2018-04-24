module WizardsCastle
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
        expect(@runner.enter_room).to eq Runner::PlayerState::ACTION
        expect(@runner.player.gp).to be > old_gold_count
        expect(@runner.castle.room(2,2,2).symbol).to eq :empty_room
      end

      it "flares" do
        old_flare_count = @runner.player.flares
        @runner.castle.set_in_room(2,2,2,:flares)
        @runner.player.set_location(2,2,2)
        expect(@runner.enter_room).to eq Runner::PlayerState::ACTION
        expect(@runner.player.flares).to be > old_flare_count
        expect(@runner.castle.room(2,2,2).symbol).to eq :empty_room
      end

      it "warp" do
        @runner.castle.set_in_room(2,2,2,:warp)
        @runner.player.set_location(2,2,2)
        allow(Castle).to receive(:random_room).and_return([5,5,5])
        expect(@runner.enter_room).to eq Runner::PlayerState::NEW_ROOM
        expect(@runner.player.location).to eq [5,5,5]
      end

      it "sinkhole" do
        @runner.castle.set_in_room(2,2,2,:sinkhole)
        @runner.player.set_location(2,2,2)
        expect(@runner.enter_room).to eq Runner::PlayerState::NEW_ROOM
        expect(@runner.player.location).to eq [2,2,3]
      end

      context "orb-of-zot" do
        before(:each) do
          @runner.castle.set_in_room(2,2,2,:orb_of_zot)
          @runner.player.set_location(2,2,2)
          @runner.player.set_facing(:s)
        end
        it "via teleport" do
          @runner.player.set_runestaff(true)
          @runner.player.set_teleported(true)
          expect(@runner.enter_room).to eq Runner::PlayerState::ACTION
          expect(@runner.player.orb_of_zot?).to eq true
          expect(@runner.player.runestaff?).to eq false
          expect(@runner.castle.room(2,2,2).symbol).to eq :empty_room
        end
        it "via other means" do
          @runner.player.set_teleported(false)
          expect(@runner.enter_room).to eq Runner::PlayerState::NEW_ROOM
          expect(@runner.player.location).to eq [3,2,2]
          expect(@runner.player.orb_of_zot?).to eq false
          expect(@runner.castle.room(2,2,2).symbol).to eq :orb_of_zot
        end
      end

      it "treasure" do
        @runner.castle.set_in_room(2,2,2,:blue_flame)
        @runner.player.set_location(2,2,2)
        expect(@runner.enter_room).to eq Runner::PlayerState::ACTION
        expect(@runner.player.have_treasure?(:blue_flame)).to eq true
        expect(@runner.castle.room(2,2,2).symbol).to eq :empty_room
      end

    end
  end
end
