module TheWizardsCastle
describe Player do

  class Player
    attr_accessor :armor_health
  end

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

  context "#set_weapon" do
    it ":nothing" do
      player.set_weapon(:nothing)
      expect(player.weapon_value).to eq 0
    end
    it ":dagger" do
      player.set_weapon(:dagger)
      expect(player.weapon_value).to eq 1
    end
    it ":mace" do
      player.set_weapon(:mace)
      expect(player.weapon_value).to eq 2
    end
    it ":sword" do
      player.set_weapon(:sword)
      expect(player.weapon_value).to eq 3
    end
  end

  context "#set_armor" do
    it ":nothing" do
      player.set_armor(:nothing)
      expect(player.armor_value).to eq 0
      expect(player.armor_health).to eq 0
    end
    it ":leather" do
      player.set_armor(:leather)
      expect(player.armor_value).to eq 1
      expect(player.armor_health).to eq 7
    end
    it ":chainmail" do
      player.set_armor(:chainmail)
      expect(player.armor_value).to eq 2
      expect(player.armor_health).to eq 14
    end
    it ":plate" do
      player.set_armor(:plate)
      expect(player.armor_value).to eq 3
      expect(player.armor_health).to eq 21
    end
  end

  context "#take_a_hit" do
    before(:each) do
      player.str(+18)
    end

    it ":nothing" do
        player.set_armor(:nothing)
      player.take_a_hit(5)
      expect(player.str).to eq 13
    end

    context ":plate" do
      before(:each) do
        player.set_armor(:plate)
      end
      it "high damage" do
        player.take_a_hit(5)
        expect(player.armor_health).to eq 18  #lost 3
        expect(player.str).to eq 16  #lost 2
        expect(player.armor).to eq :plate
      end
      it "low damage" do
        player.take_a_hit(1)
        expect(player.armor_health).to eq 20  #lost 1
        expect(player.str).to eq 18  #no loss
        expect(player.armor).to eq :plate
      end
      it "low damage" do
        player.take_a_hit(1)
        expect(player.armor_health).to eq 20  #lost 1
        expect(player.str).to eq 18  #no loss
        expect(player.armor).to eq :plate
      end
      it "destroyed" do
        player.armor_health = 1
        player.take_a_hit(5)
        expect(player.armor).to eq :nothing
        expect(player.armor_health).to eq 0
        expect(player.armor_value).to eq 0
        expect(player.str).to eq 16  #armor still blocked 3, player takes 2
      end
    end
  end

end
end
