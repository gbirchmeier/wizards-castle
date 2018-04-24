module WizardsCastle
  describe Runner do
    context "afflictions" do

      class Castle
        attr_accessor :curse_location_lethargy, :curse_location_leech, :curse_location_forgetfulness
      end

      before(:each) do
        @prompter = TestPrompter.new
        @runner = Runner.new
        @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
      end

      context "turn-start curse acquisition" do
        before(:each) do
          @runner.player.set_location(2,2,2)
          @runner.castle.set_in_room(2,2,2,:empty_room)
          @prompter.push "H"  #doesn't matter what this is
          expect(@runner.player.lethargic?).to eq false
          expect(@runner.player.leech?).to eq false
          expect(@runner.player.forgetful?).to eq false
        end
        it "lethargy" do
          @runner.castle.curse_location_lethargy = [2,2,2]
          @runner.player_action
          expect(@runner.player.lethargic?).to eq true
        end
        it "leech" do
          @runner.castle.curse_location_leech = [2,2,2]
          @runner.player_action
          expect(@runner.player.leech?).to eq true
        end
        it "forgetful" do
          @runner.castle.curse_location_forgetfulness = [2,2,2]
          @runner.player_action
          expect(@runner.player.forgetful?).to eq true
        end
      end

      context "turn-start curse effects" do
        before(:each) do
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

        end #turn-start curse effects
      end

      context "cure" do
        before(:each) do
          @prompter.push "H"
        end

        context "blindness" do
          before(:each) do
            @runner.player.set_blind(true)
          end
          it "with treasure" do
            @runner.player.add_treasure(:opal_eye)
            expect(@runner.printer).to receive(:cure_blindness)
            @runner.player_action
            expect(@runner.player.blind?).to eq false
          end
          it "nope" do
            expect(@runner.printer).not_to receive(:cure_blindness)
            @runner.player_action
            expect(@runner.player.blind?).to eq true
          end
        end

        context "stickybook" do
          before(:each) do
            @runner.player.set_stickybook(true)
          end
          it "with treasure" do
            @runner.player.add_treasure(:blue_flame)
            expect(@runner.printer).to receive(:cure_stickybook)
            @runner.player_action
            expect(@runner.player.stickybook?).to eq false
          end
          it "nope" do
            expect(@runner.printer).not_to receive(:cure_stickybook)
            @runner.player_action
            expect(@runner.player.stickybook?).to eq true
          end
        end
      end


      context "can't when blind:" do
        before(:each) do
          @runner.player.set_blind(true)
        end
        after(:each) do
          expect(@runner.printer).to receive(:blind_command_error)
          expect(@runner.player_action).to eq Runner::PlayerState::ACTION
        end

        it "M" do
          @prompter.push "M"
          expect(@runner.printer).not_to receive :display_map
        end
        it "F" do
          @prompter.push "F"
          expect(@runner).not_to receive :flare
        end
        it "L" do
          @prompter.push "L"
          expect(@runner).not_to receive :shine_lamp
        end
        it "G" do
          @runner.player.set_location(2,2,2)
          @runner.castle.set_in_room(2,2,2,:crystal_orb)
          @prompter.push "G"
          expect(@runner).not_to receive :gaze
        end
      end

    end
  end
end
