class PalindromeGenerator
  def initialize(dictionary, palindromic_sentence)
    @dictionary = dictionary
    @palindromic_sentence = palindromic_sentence
  end

  def roll_back_word
    rolled_back_word = @palindromic_sentence.roll_back
    @dictionary.add_to_legal_limbo(rolled_back_word)
    @dictionary.remove_illegal_word(rolled_back_word)
  end

  def add_to_palindrome(word)
    yield
    @dictionary.empty_legal_limbo
    @dictionary.add_illegal_word(word)
  end

  def generate
    while(@palindromic_sentence.needs_more_words)
      puts "!!!!!!!!!!!!!!!!!!!! " + @palindromic_sentence.to_s if @palindromic_sentence.palindrome?
      if @palindromic_sentence.add_to_front?
        new_word = @dictionary.find_word_starting_with(@palindromic_sentence.current_difference)
        if new_word == nil
          roll_back_word
          next
        else
          add_to_palindrome(new_word) {@palindromic_sentence.add_front(new_word)}
        end
      elsif @palindromic_sentence.add_to_back?
        new_word = @dictionary.find_word_reverse_starting_with(@palindromic_sentence.current_difference)
        if new_word == nil
          roll_back_word
          next
        else
          add_to_palindrome(new_word) {@palindromic_sentence.add_back(new_word)}
        end
      else
        roll_back_word
        next
      end
    end
  end
  
end