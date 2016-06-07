module TheWizardsCastle
class Prompter

  def ask(allowed_array,prompt_hash)
    # prompt_hash is {:prompt,:success,:error}
    loop do
      print prompt_hash[:prompt]
      input = gets.strip.upcase

      rv = nil
      if allowed_array.include?("DR")
        rv="DR" if input[0..1]=="DR"
      else
        rv=input[0] if allowed_array.include?(input[0])
      end

      if rv
        print prompt_hash[:success]
        return rv
      end

      print prompt_hash[:error]
    end
  end


  def ask_integer(min,max,prompt_hash)
    # prompt_hash is {:prompt,:success,:error,:out_of_range}
    # Negative ints are treated as errors.
    loop do
      print prompt_hash[:prompt]
      input = gets.strip

      if input.match(/^\d+$/)
        i = input.to_i
        if i<=min && i>=max
          print prompt_hash[:success]
          return i
        end
        print prompt_hash[:out_of_range]
      else
        print prompt_hash[:error]
      end
    end
  end


end
end
