class Dictionary
  def initialize(file)
    @original_words = {}
    @original_words_reverse_keys = {}
    @working_words = []
    @working_words_reversed = []
    load_words file
    @working_words = @working_words.sort.uniq
    @working_words_reversed = @working_words_reversed.sort.uniq

    @illegal_words = {}
    @legal_limbo = {}
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
        working_word = real_word.downcase.gsub(/\s*/, "")
        reversed_working_word = working_word.reverse
        @original_words[working_word] = real_word
        @original_words_reverse_keys[reversed_working_word] = real_word
        @working_words << working_word
        @working_words_reversed << reversed_working_word
      end
    end
  end

  def find_word_starting_with(prefix)
    find_word_by_prefix(prefix, @working_words, @original_words)
  end

  def find_word_reverse_starting_with(reverse_prefix)
    find_word_by_prefix(reverse_prefix,@working_words_reversed, @original_words_reverse_keys)
  end

  #non-deterministic
  def find_word_by_prefix(prefix, working_words, original_words)
    index_range = working_words.bsearch_range do |array_element|
      array_element[0, prefix.length] <=> prefix
    end

    return nil if index_range.begin == index_range.end

    random_index = index_range.begin + rand(index_range.end-index_range.begin-1)

    possible_working_word = working_words[random_index]
    possible_original_word = original_words[possible_working_word]
    if legal(possible_original_word)
      @illegal_words[possible_original_word] = ''
      expire_limbo(prefix)
      return possible_original_word
    else
      nil
    end
  end

  #  #deterministic
  #  def find_word_by_prefix(prefix, working_words, original_words)
  #    index_range = working_words.bsearch_range do |array_element|
  #      array_element[0, prefix.length] <=> prefix
  #    end
  #
  #    return nil if index_range.begin == index_range.end
  #
  #    index_range.each do |found_index|
  #      possible_working_word = working_words[found_index]
  #      possible_original_word = original_words[possible_working_word]
  #      if legal(possible_original_word)
  #        @illegal_words[possible_original_word] = ''
  #        expire_limbo(prefix)
  #        return possible_original_word
  #      end
  #    end
  #    nil
  #  end

  def legal(word)
    @illegal_words[word] == nil && @legal_limbo[word] == nil
  end

  def move_to_legal_limbo(word)
    @illegal_words.delete(word)
    @legal_limbo[word] = 100
  end

  def expire_limbo(prefix)
        @legal_limbo.keys.each do |key|
          if @legal_limbo[key] == 0
            @legal_limbo.delete(key)
          else
            @legal_limbo[key] -= 1
          end
    #      clean_key = key.downcase.gsub(/\s*/, "")
    #      clean_key_reversed = clean_key.reverse
    #      if clean_key[0, prefix.length] != prefix && clean_key_reversed[0, prefix.length] != prefix
    #        @legal_limbo[key] = nil
    #      end
        end
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
  #    
  #  end
  #
  
  #
  #  def empty_legal_limbo
  #    @legal_limbo = {}
  #  end
  #
  #  def illegal?(word)
  #    @illegal_words.key?(word) || @legal_limbo.key?(word)
  #  end

end