module WizardsCastle
describe Castle do

  class Castle
    attr_reader :curse_location_lethargy,
      :curse_location_leech,
      :curse_location_forgetfulness,
      :runestaff_location
  end

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

  context "#room" do
    it "simple" do
      expect(castle.room(1,4,1).symbol).to eq :entrance
    end

    it "curse-lethargy" do
      loc = castle.curse_location_lethargy
      expect(castle.room(*loc).cursed_with_lethargy?).to eq true
    end

    it "curse-leech" do
      loc = castle.curse_location_leech
      expect(castle.room(*loc).cursed_with_leech?).to eq true
    end

    it "curse-forgetfulness" do
      loc = castle.curse_location_forgetfulness
      expect(castle.room(*loc).cursed_with_forgetfulness?).to eq true
    end

    it "runestaff-and-monster" do
      castle.set_in_room(2,2,2,:runestaff_and_monster)
      rc = castle.room(2,2,2)
      expect(rc.symbol).to eq :runestaff_and_monster
      expect(rc.monster_symbol).to eq castle.runestaff_monster
    end
  end

  it "#set_in_room" do
    castle.set_in_room(8,8,1,:warp)
    expect(castle.rooms[63]).to eq 9 
  end

  context "@runestaff_location" do
    before(:each) do
      castle.set_in_room(8,8,1,:runestaff_and_monster)
    end
    it "after placement" do
      expect(castle.runestaff_location).to eq [8,8,1]
    end
    it "after removal" do
      castle.set_in_room(8,8,1,:empty_room)
      expect(castle.runestaff_location).to eq nil
    end
  end

  it "#flare_locs" do
    locs = Castle.flare_locs(2,2,2)
    expectation = [
      [1,1,2], [1,2,2], [1,3,2],
      [2,1,2], [2,2,2], [2,3,2],
      [3,1,2], [3,2,2], [3,3,2]
    ]
    expect(locs).to eq expectation
      
  end

end
end
