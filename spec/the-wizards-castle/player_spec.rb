module TheWizardsCastle
describe Player do

  let(:player) { Player.new }

  describe "#gp" do
    it "access" do
      expect(player.gp).to eq 60
    end
    it "alter" do
      expect(player.gp(+5)).to eq 65
      expect(player.gp(-2)).to eq 63
      expect(player.gp).to eq 63
    end
    it "can't be less than zero" do
      expect(player.gp(-100)).to eq 0
    end
  end

end
end
