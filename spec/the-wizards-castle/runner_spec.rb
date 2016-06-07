module TheWizardsCastle
describe Runner do

  class Runner
    attr_accessor :player, :prompter
  end

  context "character creation" do
    before(:each) do
      @prompter = TestPrompter.new
      @runner = Runner.new
      @runner.setup(prompter: @prompter, player: Player.new)
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
  end

end
end
