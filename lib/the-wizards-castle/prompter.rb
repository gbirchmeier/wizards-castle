module TheWizardsCastle
class Prompter

  def ask(prompt)
    print prompt
    gets.strip.upcase
  end

end
end
