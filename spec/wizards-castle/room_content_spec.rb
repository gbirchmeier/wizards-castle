module WizardsCastle
describe RoomContent do

  describe "::valid_intcode?" do
    it "true" do expect(RoomContent.valid_intcode?(1)).to eq true end
    it "false" do expect(RoomContent.valid_intcode?(1000)).to eq false end
  end

  describe "::valid_symbol?" do
    it "true" do expect(RoomContent.valid_symbol?(:empty_room)).to eq true end
    it "false" do expect(RoomContent.valid_symbol?(:burt_reynolds)).to eq false end
  end

  describe "::to_symbol" do
    it "normal" do expect(RoomContent.to_symbol(9)).to eq :warp end
    it "raise" do expect{RoomContent.to_symbol(1000)}.to raise_error(/Unrecognized intcode/) end
  end

  describe "::to_intcode" do
    it "normal" do expect(RoomContent.to_intcode(:warp)).to eq 9 end
    it "raise" do expect{RoomContent.to_intcode(:burt_reynolds)}.to raise_error(/Unrecognized symbol/) end
  end

  describe "#initialize failure" do
    it "raise" do expect{RoomContent.new(1000)}.to raise_error(/Unrecognized intcode/) end
  end

  describe "simple methods and accessors" do
    let(:warp) { RoomContent.new(9) }
    let(:lethargy) { RoomContent.new(1,true,false,false) }
    let(:leech_and_forget) { RoomContent.new(1,false,true,true) }

    it "#symbol" do expect(warp.symbol).to eq :warp end
    it "#display" do expect(warp.display).to eq "W" end

    describe "#cursed_with_lethargy?" do
      it "none" do expect(warp.cursed_with_lethargy?).to eq false end
      it "lethargy" do expect(lethargy.cursed_with_lethargy?).to eq true end
      it "others" do expect(leech_and_forget.cursed_with_lethargy?).to eq false end
    end
  end

  describe "#monster_symbol" do
    it "raises if not a monster" do
      rc = RoomContent.new(3)
      expect{rc.monster_symbol}.to raise_error /no monster in room \(has stairs_up\)/
    end
    it "kobold" do
      rc = RoomContent.new(13)
      expect(rc.monster_symbol).to eq :kobold
    end
    it "kobold" do
      rc = RoomContent.new(13)
      expect(rc.monster_symbol).to eq :kobold
    end
    it "vendor" do
      rc = RoomContent.new(25)
      expect(rc.monster_symbol).to eq :vendor
    end
    it "runestaff monster" do
      rc = RoomContent.new(35,false,false,false,:kobold)
      expect(rc.monster_symbol).to eq :kobold
    end
  end

  describe "#text" do
    it "gold" do
      rc = RoomContent.new(7)
      expect(rc.text).to eq "GOLD PIECES"
    end
    it "regular monster" do
      rc = RoomContent.new(13)
      expect(rc.text).to eq "A KOBOLD"
    end
    it "runestaff monster" do
      rc = RoomContent.new(35,false,false,false,:kobold)
      expect(rc.text).to eq "A KOBOLD"
    end
  end

end
end
