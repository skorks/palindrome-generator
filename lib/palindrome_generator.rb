class PalindromeGenerator
  def initialize(dictionary, options={})
    @dictionary = dictionary
    @previous_palindrome_size = 0
    @default_options = {:output_file => "/tmp/palindromes", :man_with_plan => true, :watch_stack => true}
    @default_options.merge!(options)
    @watch_stack = @default_options[:watch_stack]
    @output_file = @default_options[:output_file]
    @man_with_plan = @default_options[:man_with_plan]
    File.open(@output_file, 'w') {}
    @added_perfect_pairs = false
  end

  def create_palindromic_sentence()
    if @man_with_plan
      PalindromicSentence.new(["a man", "a plan"], ["a canal", "panama"])
    else
      #generate a front and back word to seed the palindrome, so that there is some overlap
      raise "Not yet implemented"
    end
  end

  def generate(palindrome_size)
    puts "Generating palindromes..."
    @palindromic_sentence = create_palindromic_sentence()

    #    Profiler__::start_profile
    while(needs_more_words?(palindrome_size))
      output_palindrome if output_palindrome?
      make_imperfect if @palindromic_sentence.perfect_palindrome?
      @dictionary.purge_limbo
      new_word = find_word_for(@palindromic_sentence)
      fail_miserably if new_word == nil
      add_word_to(@palindromic_sentence, new_word)
    end
    #    Profiler__::stop_profile
    #    Profiler__::print_profile($stderr)
  end

  def make_imperfect
    if !@added_perfect_pairs
      legal_perfect_pairs = @dictionary.legal_palindrome_pairs
      legal_perfect_pairs.each do |pair|
        add_word_to(@palindromic_sentence, pair[0])
        add_word_to(@palindromic_sentence, pair[1])
      end
      @added_perfect_pairs = true
    end
    pair = @dictionary.find_legal_back_centric_larger_to_smaller_palindromic_pair
    if pair != nil
      add_word_to(@palindromic_sentence, pair[0])
      add_word_to(@palindromic_sentence, pair[1])
    end
  end

  #  def output_palindrome?
  #    @palindromic_sentence.palindrome?
  #  end
  #
  #  def output_palindrome
  #    current_palindrome_size = @palindromic_sentence.size
  #    puts "*" * 70
  #    puts "Palindrome size: #{current_palindrome_size}"
  #    puts @palindromic_sentence.to_s
  #    puts "*" * 70
  #  end

  def output_palindrome?
    @palindromic_sentence.palindrome? && (@palindromic_sentence.size > @previous_palindrome_size + 500)
  end
  
  def output_palindrome
    current_palindrome_size = @palindromic_sentence.size
    File.open(@output_file, 'a') do |file|
      file.puts "*" * 70
      file.puts "Palindrome size: #{current_palindrome_size}"
      file.puts @palindromic_sentence.to_s
      file.puts "*" * 70
    end
    @previous_palindrome_size = current_palindrome_size
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
end