module TheWizardsCastle
describe Player do

  let(:player) { Player.new }

  context "#gp" do
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

  context "attributes" do
    it "max 18" do
      player.str(+25)
      player.int(+50)
      player.dex(+19)
      expect([player.str,player.int,player.dex]).to eq [18,18,18]
    end
    it "min 0" do
      player.str(-25)
      player.int(-50)
      player.dex(-19)
      expect([player.str,player.int,player.dex]).to eq [0,0,0]
    end
  end

  it "flares >= 0" do
    expect(player.flares(-10000)).to eq 0
  end

  it "#forget_random_room" do
    player.remember_room(2,2,2)
    player.remember_room(3,3,3)
    allow(Castle).to receive(:random_room).and_return [2,2,2]
    player.forget_random_room
    expect(player.knows_room?(2,2,2)).to eq false
    expect(player.knows_room?(3,3,3)).to eq true
  end

end
end
