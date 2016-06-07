class TestPrompter

  def initialize(seeds=[])
    @seeds = seeds
  end

  def push(a)
    if a.is_a? Array
      @seeds.concat(a)
    else
      @seeds.push(a)
    end
  end

  def ask(ignored,ignored2)
    raise "out of seeds" if @seeds.length<1
    @seeds.shift
  end

  def ask_integer(blah,blah2,blah3)
    raise "out of seeds" if @seeds.length<1
    @seeds.shift.to_i
  end

end
