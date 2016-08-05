module TheWizardsCastle
describe ShoppingTrip do


  context "#run" do
    before(:each) do
      @prompter = TestPrompter.new
      @player = Player.new
      @trip = ShoppingTrip.new(@player,NullPrinter.new,@prompter)
      @player.str(+1)
      @player.int(+1)
      @player.dex(+1)
      @player.gp(-10000) # init to 0
    end

    context "#buy_str_potions" do
      it "can't afford any" do
        expect(@prompter).not_to receive :ask
        @trip.buy_str_potions
        expect(@player.str).to eq 1
        expect(@player.gp).to eq 0
      end
      it "buy 1 and stop" do
        @prompter.push(["Y","N"])
        @player.gp(+2200)
        allow(@trip).to receive(:random_stat_gain).and_return(5)
        @trip.buy_str_potions
        expect(@player.str).to eq 6
        expect(@player.gp).to eq 1200
      end
      it "buy 2, can't afford more" do
        @prompter.push(["Y","Y"])
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
end
