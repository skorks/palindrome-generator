class PalindromeGenerator
  def initialize(dictionary)
    @dictionary = dictionary
  end

  def create_palindromic_sentence(man_with_plan=true)
    if man_with_plan == nil || man_with_plan
      PalindromicSentence.new(["a man", "a plan"], ["a canal", "panama"])
    else
      #generate a front and back word to seed the palindrome, so that there is some overlap
      raise "Not yet implemented"
    end
  end

  def output_palindrome
    puts "*" * 80
    puts "Palindrome size: #{@palindromic_sentence.size}"
    puts @palindromic_sentence.to_s
    puts "*" * 80
  end

  def generate(palindrome_size, options={})
    @palindromic_sentence = create_palindromic_sentence(options[:man_with_plan])

    while(@palindromic_sentence.size < palindrome_size)
      output_palindrome if @palindromic_sentence.palindrome?

      if @palindromic_sentence.needs_rollback?
        roll_back_word
      else
        new_word = @dictionary.find_word_starting_with(@palindromic_sentence.current_difference, 
          @palindromic_sentence.reverse_word?)
        if new_word == nil
          roll_back_word
        else
          add_to_palindrome(new_word) {@palindromic_sentence.add_word(new_word)}
          puts @palindromic_sentence.current_stack if options[:watch_stack]
        end
      end
    end
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
end