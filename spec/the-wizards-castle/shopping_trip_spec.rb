module TheWizardsCastle
describe ShoppingTrip do

  before(:each) do
    @prompter = TestPrompter.new
    @player = Player.new
    @trip = ShoppingTrip.new(@player,NullPrinter.new,@prompter)
    @player.str(+1)
    @player.int(+1)
    @player.dex(+1)
    @player.gp(-10000) # init to 0
  end

  context "#sell_treasures" do
    it "sell, keep, sell" do
      @prompter.push ["Y","N","Y"]
      @player.add_treasure(:blue_flame) #index 5
      @player.add_treasure(:norn_stone) #index 1
      @player.add_treasure(:green_gem)  #index 4
      allow(@trip).to receive(:random_treasure_offer).and_return(2000,3000,4000)
      @trip.sell_treasures
      expect(@player.gp).to eq 6000
      expect(@player.have_treasure?(:norn_stone)).to eq false
      expect(@player.have_treasure?(:green_gem)).to eq true
      expect(@player.have_treasure?(:blue_flame)).to eq false
    end
  end

  context "#buy_armor" do
    it "have nothing, buy plate" do
      @player.set_armor(:nothing)
      @player.gp(+3333)
      @prompter.push("P")
      @trip.buy_armor
      expect(@player.gp).to eq 1333
      expect(@player.armor).to eq :plate
    end

    it "have plate, buy leather" do
      @player.set_armor(:plate)
      @player.gp(+3333)
      @prompter.push("L")
      @trip.buy_armor
      expect(@player.gp).to eq 2083
      expect(@player.armor).to eq :leather
    end

    it "have chainmail, don't change it" do
      @player.set_armor(:chainmail)
      @player.gp(+3333)
      @prompter.push("N")
      @trip.buy_armor
      expect(@player.gp).to eq 3333
      expect(@player.armor).to eq :chainmail
    end
  end

  context "#buy_weapon" do
    it "have nothing, buy sword" do
      @player.set_weapon(:nothing)
      @player.gp(+3333)
      @prompter.push("S")
      @trip.buy_weapon
      expect(@player.gp).to eq 1333
      expect(@player.weapon).to eq :sword
    end

    it "have sword, buy dagger" do
      @player.set_weapon(:sword)
      @player.gp(+3333)
      @prompter.push("D")
      @trip.buy_weapon
      expect(@player.gp).to eq 2083
      expect(@player.weapon).to eq :dagger
    end

    it "have mace, don't change it" do
      @player.set_weapon(:mace)
      @player.gp(+3333)
      @prompter.push("N")
      @trip.buy_weapon
      expect(@player.gp).to eq 3333
      expect(@player.weapon).to eq :mace
    end
  end

  context "#buy_str_potions" do
    it "can't afford any" do
      expect(@prompter).not_to receive :ask
      @trip.buy_str_potions
      expect(@player.str).to eq 1
      expect(@player.gp).to eq 0
    end
    it "buy 1 and stop" do
      @prompter.push ["Y","N"]
      @player.gp(+2200)
      allow(@trip).to receive(:random_stat_gain).and_return(5)
      @trip.buy_str_potions
      expect(@player.str).to eq 6
      expect(@player.gp).to eq 1200
    end
    it "buy 2, can't afford more" do
      @prompter.push ["Y","Y"]
      @player.gp(+2001)
      allow(@trip).to receive(:random_stat_gain).and_return(5,2)
      @trip.buy_str_potions
      expect(@player.str).to eq 8
      expect(@player.gp).to eq 1
    end
  end

  context "#buy_int_potions" do
    it "buy 1 and stop" do
      @prompter.push(["Y","N"])
      @player.gp(+2200)
      allow(@trip).to receive(:random_stat_gain).and_return(5)
      @trip.buy_int_potions
      expect(@player.int).to eq 6
      expect(@player.gp).to eq 1200
    end
  end

  context "#buy_dex_potions" do
    it "buy 2, can't afford more" do
      @prompter.push(["Y","Y"])
      @player.gp(+2001)
      allow(@trip).to receive(:random_stat_gain).and_return(5,2)
      @trip.buy_dex_potions
      expect(@player.dex).to eq 8
      expect(@player.gp).to eq 1
    end
  end

end
end
