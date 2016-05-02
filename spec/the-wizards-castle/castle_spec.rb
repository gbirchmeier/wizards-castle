module TheWizardsCastle
describe Castle do

  let(:castle) { Castle.new }

  it "::get_room_index" do
    expect(Castle.room_index(1,1,1)).to eq 0
    expect(Castle.room_index(8,8,8)).to eq (8*8*8)-1
    expect(Castle.room_index(8,8,1)).to eq 63
    expect(Castle.room_index(1,1,2)).to eq 64
  end

  it "#room" do
    castle.rooms[63] = 9
    expect(castle.room(8,8,1).intcode).to eq 9
  end

  it "#set_in_room" do
    castle.set_in_room(8,8,1,:warp)
    expect(castle.rooms[63]).to eq 9 
  end

  it "debug display" do
    c = Castle.new
    puts c.debug_display.join("\n")
  end

end
end
