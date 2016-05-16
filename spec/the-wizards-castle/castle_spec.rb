module TheWizardsCastle
describe Castle do

  let(:castle) { Castle.new }

  it "::get_room_index" do
    expect(Castle.room_index(1,1,1)).to eq 0
    expect(Castle.room_index(1,2,1)).to eq 1
    expect(Castle.room_index(2,1,1)).to eq 8
    expect(Castle.room_index(1,1,2)).to eq (8*8)
    expect(Castle.room_index(1,1,8)).to eq (8*8*7)
    expect(Castle.room_index(8,8,8)).to eq (8*8*8)-1
  end

  it "#room" do
    expect(castle.room(1,4,1).symbol).to eq :entrance
  end

  it "#set_in_room" do
    castle.set_in_room(8,8,1,:warp)
    expect(castle.rooms[63]).to eq 9 
  end

  it "debug display" do
    c = Castle.new
#    puts c.debug_display.join("\n")
  end

end
end
