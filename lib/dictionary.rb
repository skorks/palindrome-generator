class Dictionary
  def initialize(file)
    @original_words = {}
    @working_words = []
    @working_words_reversed = []
    load_words file
    @working_words = @working_words.sort.uniq
    @working_words_reversed = @working_words_reversed.sort.uniq


    
    #    @illegal_words = {}
    #    @legal_limbo = {}
    #    @words_string = @words.join(" ")
    #    @reverse_words_string = @words_string.reverse
    #
    #    puts @words_string.match("\s+p.*\s+").size
    #
    #    exit
  end

  def load_words(file)
    File.open(file, "r").each do |word|
      if(word.index(/'/) == nil)
        real_word = word.chop.strip
        working_word = real_word.downcase.gsub(/\s/, "")
        reversed_working_word = working_word.reverse
        @original_words[working_word] = real_word
        @original_words[reversed_working_word] = real_word
        @working_words << working_word
        @working_words_reversed << reversed_working_word
      end
    end
  end

  def find_word_starting_with(prefix)
#    index = @working_words.bsearch_first(prefix)
#    current_word = @working_words[index]
#    original_current_word = @original_words[current_word]
#    [current_word, original_current_word]
  end

  def find_word_reverse_startig_with(prefix)
#    index = @working_words_reversed.binary_search(prefix)
#    current_word = @working_words_reversed[index]
#    original_current_word = @original_words[current_word]
#    [current_word, original_current_word]
  end







  #  def find_word_starting_with(string, reverse_word)
  #    if reverse_word
  #
  #    else
  #      puts @words_string
  #      blah = @words_string.match("\s*#{string}\s*")
  #      puts "^^^^^^^^^^^^^^^^^^^^^^ #{string}"
  #    end
  #
  #
  #    #    find_word(string) do |word, string|
  #    #      if reverse_word
  #    #        word.reverse.index(string) == 0
  #    #      else
  #    #        word.index(string) == 0
  #    #      end
  #    #    end
  #  end
  #
  #  def find_word(string)
  #    @words.each do |word|
  #      if yield(word, string) && !illegal?(word)
  #        return word
  #      end
  #    end
  #    nil
  #  end

  #  def add_illegal_word(word)
  #    @illegal_words[word]=''
  #  end
  #
  #  def remove_illegal_word(word)
  #    @illegal_words.delete(word)
  #  end
  #
  #  def add_to_legal_limbo(word)
  #    @legal_limbo[word] = ''
  #  end
  #
  #  def empty_legal_limbo
  #    @legal_limbo = {}
  #  end
  #
  #  def illegal?(word)
  #    @illegal_words.key?(word) || @legal_limbo.key?(word)
  #  end

end