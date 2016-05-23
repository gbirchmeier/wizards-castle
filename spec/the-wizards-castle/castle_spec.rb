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

  it "::north" do
    expect(Castle.north(5,3,1)).to eq [4,3,1]
    expect(Castle.north(1,3,1)).to eq [8,3,1]
  end

  it "::south" do
    expect(Castle.south(5,3,1)).to eq [6,3,1]
    expect(Castle.south(8,3,1)).to eq [1,3,1]
  end

  it "::west" do
    expect(Castle.west(5,3,1)).to eq [5,2,1]
    expect(Castle.west(5,1,1)).to eq [5,8,1]
  end

  it "::east" do
    expect(Castle.east(5,3,1)).to eq [5,4,1]
    expect(Castle.east(5,8,1)).to eq [5,1,1]
  end

  it "::down" do
    expect(Castle.down(5,3,4)).to eq [5,3,5]
    expect(Castle.down(5,3,8)).to eq [5,3,1]
  end

  it "::up" do
    expect(Castle.up(5,3,4)).to eq [5,3,3]
    expect(Castle.up(5,3,1)).to eq [5,3,8]
  end

  it "#room" do
    expect(castle.room(1,4,1).symbol).to eq :entrance
  end

  it "#set_in_room" do
    castle.set_in_room(8,8,1,:warp)
    expect(castle.rooms[63]).to eq 9 
  end



end
end
