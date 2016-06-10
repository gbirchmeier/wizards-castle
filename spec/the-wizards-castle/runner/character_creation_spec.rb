module TheWizardsCastle
describe Runner do
context "character creation" do


  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
  end


  context "#ask_race" do
    it "human" do
      @prompter.push("M")
      @runner.ask_race
      expect(@runner.player.race).to eq :human
      expect(@runner.player.str).to eq 8
      expect(@runner.player.int).to eq 8
      expect(@runner.player.dex).to eq 8
      expect(@runner.player.custom_attribute_points).to eq 8
    end
    it "hobbit" do
      @prompter.push("H")
      @runner.ask_race
      expect(@runner.player.race).to eq :hobbit
      expect(@runner.player.str).to eq 4
      expect(@runner.player.int).to eq 8
      expect(@runner.player.dex).to eq 12
      expect(@runner.player.custom_attribute_points).to eq 4
    end
  end


  context "#ask_gender" do
    it "male" do
      @prompter.push("M")
      @runner.ask_gender
      expect(@runner.player.gender).to eq :male
    end
    it "female" do
      @prompter.push("F")
      @runner.ask_gender
      expect(@runner.player.gender).to eq :female
    end
  end


  context "#ask_attributes" do
    it "no-point hobbit" do
      @prompter.push ["H",0,0,0]
      @runner.ask_race
      @runner.ask_attributes
      expect(@runner.player.race).to eq :hobbit
      expect(@runner.player.str).to eq 4
      expect(@runner.player.int).to eq 8
      expect(@runner.player.dex).to eq 12
    end

    it "#ask_strength" do
      @prompter.push ["M",5]
      @runner.ask_race
      @runner.ask_strength
      expect(@runner.player.race).to eq :human
      expect(@runner.player.str).to eq 13
      expect(@runner.player.int).to eq 8
      expect(@runner.player.dex).to eq 8
    end

    it "#ask_intelligence" do
      @prompter.push ["M",7]
      @runner.ask_race
      @runner.ask_intelligence
      expect(@runner.player.race).to eq :human
      expect(@runner.player.str).to eq 8
      expect(@runner.player.int).to eq 15
      expect(@runner.player.dex).to eq 8
    end

    it "#ask_dexterity" do
      @prompter.push ["M",8]
      @runner.ask_race
      @runner.ask_dexterity
      expect(@runner.player.race).to eq :human
      expect(@runner.player.str).to eq 8
      expect(@runner.player.int).to eq 8
      expect(@runner.player.dex).to eq 16
    end
  end


  context "buy stuff" do
    before(:each) do
      expect(@runner.player.gp).to eq 60
    end

    it "ask_armor" do
      @prompter.push "C"
      @runner.ask_armor
      expect(@runner.player.gp).to eq 40
      expect(@runner.player.armor).to eq :chainmail
    end

    it "ask_weapon" do
      @prompter.push "D"
      @runner.ask_weapon
      expect(@runner.player.gp).to eq 50
      expect(@runner.player.weapon).to eq :dagger
    end

    context "#ask_lamp" do
      it "yes" do
        @prompter.push "Y"
        @runner.ask_lamp
        expect(@runner.player.lamp?).to eq true
        expect(@runner.player.gp).to eq 40
      end
      it "no" do
        @prompter.push "N"
        @runner.ask_lamp
        expect(@runner.player.lamp?).to eq false
        expect(@runner.player.gp).to eq 60
      end
    end

    context "#ask_flares" do
      it "0" do
        @prompter.push 0
        @runner.ask_flares
        expect(@runner.player.flares).to eq 0
        expect(@runner.player.gp).to eq 60
      end
      it "25" do
        @prompter.push 25
        @runner.ask_flares
        expect(@runner.player.flares).to eq 25
        expect(@runner.player.gp).to eq 35
      end
    end
  end #buy stuff


end #character creation
end
end
