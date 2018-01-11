class TestPrompter
  # matches interface of WizardsCastle::Prompter

  def initialize(seeds = [])
    @seeds = seeds
  end

  def push(a)
    if a.is_a? Array
      @seeds.concat(a)
    else
      @seeds.push(a)
    end
  end

  def ask(_allowed_array, _prompt_hash)
    raise 'out of seeds' if @seeds.empty?
    @seeds.shift
  end

  def ask_integer(_blah, _blah2, _blah3)
    raise 'out of seeds' if @seeds.empty?
    @seeds.shift.to_i
  end

  def ask_for_anything(_prompt_hash)
    raise 'out of seeds' if @seeds.empty?
    @seeds.shift
  end

  def confirm(_blah, _blah2)
    # you should push booleans for this one
    raise 'out of seeds' if @seeds.empty?
    @seeds.shift
  end

end
