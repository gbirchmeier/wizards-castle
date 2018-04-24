module WizardsCastle
  class Prompter

    def ask(allowed_array,prompt_hash)
      # prompt_hash is {:prompt,:success,:error}
      loop do
        emit prompt_hash[:prompt]
        input = gets.to_s.strip.upcase

        rv = nil
        if allowed_array.include?("DR") && input[0..1]=="DR"
          rv="DR"
        else
          rv=input[0] if allowed_array.include?(input[0])
        end

        if rv
          emit_with_arg(prompt_hash[:success],rv)
          return rv
        end

        emit prompt_hash[:error]
      end
    end


    def ask_integer(min,max,prompt_hash)
      # prompt_hash is {:prompt,:success,:error,:out_of_range}
      # Negative ints are treated as errors.
      loop do
        emit prompt_hash[:prompt]
        input = gets.to_s.strip

        if input.match(/^\d+$/)
          i = input.to_i
          if i>=min && i<=max
            emit prompt_hash[:success]
            return i
          end
          emit prompt_hash[:out_of_range]
        else
          emit prompt_hash[:error]
        end
      end
    end

    def ask_for_anything(prompt_hash)
      emit prompt_hash[:prompt]
      rv = gets.to_s.strip.upcase
      emit_with_arg(prompt_hash[:success],rv)
      rv
    end


    def confirm(target,prompt_hash)
      emit prompt_hash[:prompt]
      input = gets.to_s.strip.upcase
      if input.start_with?(target)
        emit prompt_hash[:confirmed]
        return true
      else
        emit prompt_hash[:denied]
        return false
      end
    end

    private

    def emit x
      output = x.is_a?(Proc) ? x.call : x
      print output
    end

    def emit_with_arg x, arg
      output = x.is_a?(Proc) ? x.call(arg) : x
      print output
    end

  end
end
