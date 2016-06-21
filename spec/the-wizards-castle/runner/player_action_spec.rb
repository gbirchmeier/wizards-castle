module TheWizardsCastle
describe Runner do
context "#player_action" do

  class Player
    attr_reader :room_memory
  end


  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)

    #useful for debugging
    #@runner.printer = StetsonPrinter.new(@runner.player)
  end

  it "H" do
    @prompter.push("H")
    expect(@runner.printer).to receive(:help_message)
    expect(@runner.player_action).to eq Runner::PlayerState::ACTION
  end

  context "basic movement:" do
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
      expect(@runner.player_action).to eq Runner::PlayerState::NEW_ROOM
      expect(@runner.player.location).to eq [1,2,2]
      expect(@runner.player.facing).to eq :n
    end
    it "S" do
      @prompter.push("S")
      expect(@runner.player_action).to eq Runner::PlayerState::NEW_ROOM
      expect(@runner.player.location).to eq [3,2,2]
      expect(@runner.player.facing).to eq :s
    end
    it "W" do
      @prompter.push("W")
      expect(@runner.player_action).to eq Runner::PlayerState::NEW_ROOM
      expect(@runner.player.location).to eq [2,1,2]
      expect(@runner.player.facing).to eq :w
    end
    it "E" do
      @prompter.push("E")
      expect(@runner.player_action).to eq Runner::PlayerState::NEW_ROOM
      expect(@runner.player.location).to eq [2,3,2]
      expect(@runner.player.facing).to eq :e
    end
  end

  context "entrance move:" do
    before(:each) do
      @runner.castle.set_in_room(2,2,2,:entrance)
      @runner.castle.set_in_room(2,1,2,:empty_room)
      @runner.player.set_location(2,2,2)
    end

    it "N" do
      @prompter.push "N"
      expect(@runner.player_action).to eq Runner::PlayerState::EXITED
    end

    it "W" do
      @prompter.push "W"
      expect(@runner.player_action).to eq Runner::PlayerState::NEW_ROOM
      expect(@runner.player.facing).to eq :w
    end
  end

  context "stairs" do
    context "no stairs present" do
      before(:each) do
        @runner.castle.set_in_room(2,2,2,:empty_room)
        @runner.player.set_location(2,2,2)
      end
      it "U" do
        @prompter.push "U"
        expect(@runner.printer).to receive(:stairs_up_error)
        expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      end
      it "D" do
        @prompter.push "D"
        expect(@runner.printer).to receive(:stairs_down_error)
        expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      end
    end

    it "U" do
      @prompter.push "U"
      @runner.castle.set_in_room(2,2,3,:stairs_up)
      @runner.player.set_location(2,2,3)
      expect(@runner.player_action).to eq Runner::PlayerState::NEW_ROOM
      expect(@runner.player.location).to eq [2,2,2]
    end
    it "D" do
      @prompter.push "D"
      @runner.castle.set_in_room(2,2,2,:stairs_down)
      @runner.player.set_location(2,2,2)
      expect(@runner.player_action).to eq Runner::PlayerState::NEW_ROOM
      expect(@runner.player.location).to eq [2,2,3]
    end
  end

  context "DR" do
    before(:each) do
      @runner.player.str(+8)
      @runner.player.int(+8)
      @runner.player.dex(+8)
      @runner.player.set_race(:human)
      @runner.player.set_gender(:male)
      @runner.player.set_location(2,2,2)
      @runner.castle.set_in_room(2,2,2,:magic_pool)
      @prompter.push "DR"
    end

    it "no pool present" do
      @runner.castle.set_in_room(2,2,2,:empty_room)
      expect(@runner.printer).to receive(:drink_error)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
    end

    it "stronger" do
      allow(@runner).to receive(:random_drink_effect).and_return(:stronger)
      allow(@runner).to receive(:random_drink_attr_change).and_return(3)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.str).to eq 11
    end
    it "weaker" do
      allow(@runner).to receive(:random_drink_effect).and_return(:weaker)
      allow(@runner).to receive(:random_drink_attr_change).and_return(1)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.str).to eq 7
    end
    it "smarter" do
      allow(@runner).to receive(:random_drink_effect).and_return(:smarter)
      allow(@runner).to receive(:random_drink_attr_change).and_return(2)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.int).to eq 10
    end
    it "dumber" do
      allow(@runner).to receive(:random_drink_effect).and_return(:dumber)
      allow(@runner).to receive(:random_drink_attr_change).and_return(3)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.int).to eq 5
    end
    it "nimbler" do
      allow(@runner).to receive(:random_drink_effect).and_return(:nimbler)
      allow(@runner).to receive(:random_drink_attr_change).and_return(2)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.dex).to eq 10
    end
    it "clumsier" do
      allow(@runner).to receive(:random_drink_effect).and_return(:clumsier)
      allow(@runner).to receive(:random_drink_attr_change).and_return(3)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.dex).to eq 5
    end
    it "change_race" do
      allow(@runner).to receive(:random_drink_effect).and_return(:change_race)
      allow(@runner).to receive(:random_drink_race_change).and_return(:elf)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.race).to eq :elf
    end
    it "change_gender" do
      allow(@runner).to receive(:random_drink_effect).and_return(:change_gender)
      allow(@runner).to receive(:random_drink_race_change).and_return(:female)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.gender).to eq :female
    end

    it "died due to low attribute" do
      expect(@runner.player.str(-7)).to eq 1
      allow(@runner).to receive(:random_drink_effect).and_return :weaker
      expect(@runner.player_action).to eq Runner::PlayerState::DIED
    end
  end #DR


  it "M" do
    @prompter.push "M"
    expect(@runner.printer).to receive(:display_map)
    expect(@runner.player_action).to eq Runner::PlayerState::ACTION
  end

  context "F" do
    before(:each) do
      @prompter.push "F"
      @runner.player.set_location(2,2,2)
      @runner.player.remember_room(2,2,2)
      expect(@runner.player.room_memory.count(true)).to eq 1
      expect(@runner.player.flares).to eq 0
    end
    it "success" do
      @runner.player.flares(+3)
      expect(@runner.printer).to receive(:flare)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.room_memory.count(true)).to eq 9
      expect(@runner.player.flares).to eq 2
    end
    it "out of flares" do
      expect(@runner.printer).to receive(:out_of_flares)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.room_memory.count(true)).to eq 1
    end
  end

  context "L" do
    before(:each) do
      @runner.player.set_location(2,2,2)
      @runner.player.remember_room(2,2,2)
      expect(@runner.player.room_memory.count(true)).to eq 1
      @prompter.push ["L","W"]
    end
    it "have lamp" do
      @runner.player.set_lamp(true)
      expect(@runner.printer).to receive(:lamp_shine)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.knows_room?(2,1,2)).to eq true
      expect(@runner.player.room_memory.count(true)).to eq 2
    end
    it "no lamp" do
      expect(@runner.printer).to receive(:no_lamp_error)
      expect(@runner.player_action).to eq Runner::PlayerState::ACTION
      expect(@runner.player.room_memory.count(true)).to eq 1
    end
  end

end
end
end
