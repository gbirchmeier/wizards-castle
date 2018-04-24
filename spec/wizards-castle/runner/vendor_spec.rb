module WizardsCastle
  describe Runner do
    context 'vendor' do

      before(:each) do
        @prompter = TestPrompter.new
        @runner = Runner.new
        @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
        @runner.castle.set_in_room(2, 2, 2, :vendor)
        @runner.player.set_location(2, 2, 2)
      end

      context 'enter_room triggers:' do
        it 'ignore him' do
          @prompter.push 'I'
          expect(@runner.enter_room).to eq Runner::PlayerState::ACTION
        end

        it 'get attacked (and run away)' do
          @runner.player.set_vendor_rage(true)
          allow(@runner).to receive(:combat).and_return Runner::PlayerState::NEW_ROOM
          expect(@runner.enter_room).to eq Runner::PlayerState::NEW_ROOM
        end

        it 'attack (and get killed)' do
          @prompter.push 'A'
          expect(@runner.printer).to receive :vendor_responds_to_attack
          allow(@runner).to receive(:combat).and_return Runner::PlayerState::DIED
          expect(@runner.enter_room).to eq Runner::PlayerState::DIED
          expect(@runner.player.vendor_rage?).to eq true
        end
      end

      context 'combat scenarios:' do
        it 'kill him and get his loot' do
          @runner.player.set_weapon(:dagger)
          @runner.player.set_armor(:leather)
          expect(@runner.player.gp).to eq 60
          @runner.player.set_lamp(false)
          @runner.player.str(+8)
          @runner.player.int(+8)
          @runner.player.dex(+8)

          allow(@runner).to receive(:run_battle).and_return BattleRunner::Result::ENEMY_DEAD
          expect(@runner.combat).to eq Runner::PlayerState::ACTION

          expect(@runner.player.weapon).to eq :sword
          expect(@runner.player.armor).to eq :plate
          expect(@runner.player.gp).to be > 60
          expect(@runner.player.str).to be > 8
          expect(@runner.player.int).to be > 8
          expect(@runner.player.dex).to be > 8
          expect(@runner.player.lamp?).to eq true
          expect(@runner.castle.room(2, 2, 2).symbol).to eq :empty_room
        end

        it 'get attacked and bribe him happy' do
          @runner.player.set_vendor_rage(true)
          allow(@runner).to receive(:run_battle).and_return BattleRunner::Result::BRIBED
          expect(@runner.combat).to eq Runner::PlayerState::ACTION
          expect(@runner.player.vendor_rage?).to eq false
        end
      end

    end
  end
end
