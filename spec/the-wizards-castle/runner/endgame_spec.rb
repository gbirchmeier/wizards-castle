module TheWizardsCastle
describe Runner do
context "endgame" do

  before(:each) do
    @prompter = TestPrompter.new
    @runner = Runner.new
    @runner.setup(prompter: @prompter, player: Player.new, printer: NullPrinter.new)
    @runner.player.str(+1)
    @runner.player.int(+1)
    @runner.player.dex(+1)
  end

  it "quit, no replay" do
    @prompter.push ["Q","Y","N"]
    expect(@runner.printer).to receive(:quit)
    expect(@runner.printer).to receive(:shut_down)
    expect(@runner.play).to eq false
  end

  it "quit, yes replay" do
    @prompter.push ["Q","Y","Y"]
    expect(@runner.printer).to receive(:quit)
    expect(@runner.printer).to receive(:play_again)
    expect(@runner.play).to eq true
  end

  it "exit castle, no replay" do
    @prompter.push ["N","N"]
    expect(@runner.printer).to receive(:exit_castle)
    expect(@runner.printer).to receive(:shut_down)
    expect(@runner.play).to eq false
  end

  it "death (by gaze STR loss), no replay" do
    @prompter.push ["W","G","N"]
    @runner.castle.set_in_room(1,3,1,:crystal_orb)
    allow(@runner).to receive(:random_gaze_effect).and_return :bloody_heap

    expect(@runner.printer).to receive(:death)
    expect(@runner.printer).to receive(:shut_down)
    expect(@runner.play).to eq false
  end

end
end
end
