class PalindromeGenerator
  def initialize(dictionary)
    @dictionary = dictionary
    @watch_stack = false
  end

  def create_palindromic_sentence(man_with_plan=true)
    if man_with_plan == nil || man_with_plan
      PalindromicSentence.new(["a man", "a plan"], ["a canal", "panama"])
    else
      #generate a front and back word to seed the palindrome, so that there is some overlap
      raise "Not yet implemented"
    end
  end

  def generate(palindrome_size, options={})
    @watch_stack = options[:watch_stack]
    @palindromic_sentence = create_palindromic_sentence(options[:man_with_plan])
    
    while(needs_more_words?(palindrome_size))
      output_palindrome if @palindromic_sentence.palindrome?
      new_word = find_word_for(@palindromic_sentence)
      fail_miserably if new_word == nil
      add_word_to(@palindromic_sentence, new_word)
    end
  end

  def output_palindrome
    puts "*" * 70
    puts "Palindrome size: #{@palindromic_sentence.size}"
    puts @palindromic_sentence.to_s
    puts "*" * 70
  end

  def needs_more_words?(size)
    size > @palindromic_sentence.size
  end

  def add_word_to(palindromic_sentence, word)
    palindromic_sentence.add_word(word)
    puts palindromic_sentence.current_stack if @watch_stack
  end

  def has_been_used(word)
    used_words[word]=''
  end

  def fail_miserably
    puts "Massive palindrome fail!"
    exit
  end

  def find_word_for(palindromic_sentence)
    next_word = lookup_word(palindromic_sentence)
    while(next_word == nil)
      roll_back_word(palindromic_sentence)
      next_word = lookup_word(palindromic_sentence)
    end
    next_word
  end

  def lookup_word(palindromic_sentence)
    return nil if palindromic_sentence.perfect_palindrome?
    if palindromic_sentence.needs_word_at_front?
      @dictionary.find_word_starting_with(palindromic_sentence.current_difference)
    else
      @dictionary.find_word_reverse_starting_with(palindromic_sentence.current_difference)
    end
  end

  def roll_back_word(palindromic_sentence)
    rolled_back_word = palindromic_sentence.roll_back
    @dictionary.move_to_legal_limbo(rolled_back_word)
  end
  
  #  def generate(palindrome_size, options={})
  #    @palindromic_sentence = create_palindromic_sentence(options[:man_with_plan])
  #
  #    while(@palindromic_sentence.size < palindrome_size)
  #      output_palindrome if @palindromic_sentence.palindrome?
  #
  #      if @palindromic_sentence.needs_rollback?
  #        roll_back_word
  #      else
  #        new_word = @dictionary.find_word_starting_with(@palindromic_sentence.current_difference,
  #          @palindromic_sentence.reverse_word?)
  #        if new_word == nil
  #          roll_back_word
  #        else
  #          add_to_palindrome(new_word) {@palindromic_sentence.add_word(new_word)}
  #          puts @palindromic_sentence.current_stack if options[:watch_stack]
  #        end
  #      end
  #    end
  #  end



end