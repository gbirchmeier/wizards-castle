module TheWizardsCastle
describe Player do

  let(:player) { Player.new }

  describe "#gp" do
    it "after init" do
      expect(player.gp).to eq 0
    end
    it "add" do
      expect(player.gp(+5)).to eq 5
      expect(player.gp(-2)).to eq 3
      expect(player.gp).to eq 3
    end
  end

end
end
