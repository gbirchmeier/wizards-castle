module TheWizardsCastle
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
    let(:lethargy) { RoomContent.new(1,1,0,0)
    let(:leech_and_forget) { RoomContent.new(1,0,1,1)

    it "#symbol" do expect(warp.symbol).to eq :warp end
    it "#intcode" do expect(warp.intcode).to eq 9 end
    it "#display" do expect(warp.display).to eq "W" end

    describe "#cursed_with_lethargy?"
      it "none" do expect(warp.cursed_with_lethargy?).to eq false end
      it "lethargy" do expect(lethargy.cursed_with_lethargy?).to eq true end
      it "others" do expect(leech_and_forget.cursed_with_lethargy?).to eq false end
    end
  end

end
end
