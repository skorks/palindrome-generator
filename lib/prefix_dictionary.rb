class Array
  def shuffle!
    each_index do |i|
      j = rand(length-i) + i
      self[j], self[i] = self[i], self[j]
    end
  end

  def shuffle
    dup.shuffle!
  end
end


class PrefixDictionary
  def initialize(file)
    puts "Indexing ..."
    @original_words = {}
    @original_words_reverse_keys = {}

    @illegal_words = {}
    @legal_limbo = {}
    
    @prefix_to_word = {}
    @prefix_to_word_reversed = {}
    
    load_words file
    clean_up_prefix_map(@prefix_to_word, @prefix_to_word_reversed)
    clean_up_prefix_map(@prefix_to_word_reversed, @prefix_to_word)
  end

  #for each prefix
  #for every word associated with that prefix
  #remove prefix from word
  #if what it left over is not a reverse prefix
  #disassociate the word from the prefix
  def clean_up_prefix_map(prefix_map, reverse_map)
    prefix_map.keys.each do |prefix|
      clean_word_list = []
      prefix_map[prefix].each do |word|
        word_length = word.length
        prefix_length = prefix.length
        suffix = word[prefix_length, word_length - prefix_length]
        clean_word_list << word if reverse_map[suffix] != nil
      end
      prefix_map[prefix] = clean_word_list
    end
  end

  def load_words(file)
    File.open(file, "r").each do |word|
      real_word = word.chop.strip
      working_word = real_word.downcase.gsub(/[^a-z]/, "")
      next if working_word.length == 0
      reversed_working_word = working_word.reverse
      @original_words[working_word] = real_word
      @original_words_reverse_keys[reversed_working_word] = real_word
      #        @working_words << working_word
      #        @working_words_reversed << reversed_working_word
      index_by_prefix(working_word) { @prefix_to_word }
      index_by_prefix(reversed_working_word) {@prefix_to_word_reversed}
    end
  end

  def index_by_prefix(word)
    current_prefix_length = 1
    while current_prefix_length <= word.length
      yield[word[0, current_prefix_length]] ||= []
      yield[word[0, current_prefix_length]] << word
      current_prefix_length += 1
    end
  end

  def find_word_starting_with(prefix)
    find_word_by_prefix(prefix, @prefix_to_word, @original_words)
  end

  def find_word_reverse_starting_with(reverse_prefix)
    find_word_by_prefix(reverse_prefix, @prefix_to_word_reversed, @original_words_reverse_keys)
  end


  #non-deterministic 2
  def find_word_by_prefix(prefix, prefix_to_word_map, original_words)
    all_words_by_prefix = prefix_to_word_map[prefix]
    return nil if all_words_by_prefix == nil || all_words_by_prefix.length == 0
    all_words_by_prefix = all_words_by_prefix.shuffle
    all_words_by_prefix.each do |working_word|
      original_word = original_words[working_word]
      if legal(original_word)
        @illegal_words[original_word] = 1
        puts "Illegals: #{@illegal_words.keys.size}, Limbo: #{@legal_limbo.keys.size}"
        return original_word
      end
    end
    nil
  end

  #  #non-deterministic
  #  def find_word_by_prefix(prefix, prefix_to_word_map, original_words)
  #    all_words_by_prefix = prefix_to_word_map[prefix]
  #    temp_array = []
  #    return nil if all_words_by_prefix == nil || all_words_by_prefix.length == 0
  #    rand_index = rand(all_words_by_prefix.length - 1)
  #    working_word = all_words_by_prefix.delete_at(rand_index)
  #    original_word = original_words[working_word]
  #    temp_array << working_word
  #
  #    while !legal(original_word)
  #      return nil if all_words_by_prefix.length == 0
  #      rand_index = rand(all_words_by_prefix.length - 1)
  #      working_word = all_words_by_prefix.delete_at(rand_index)
  #      original_word = original_words[working_word]
  #      temp_array << working_word
  #    end
  #    @illegal_words[original_word] = 1
  #    prefix_to_word_map[prefix] = all_words_by_prefix + temp_array
  #    puts "Illegals: #{@illegal_words.keys.size}, Limbo: #{@legal_limbo.keys.size}"
  #    original_word
  #  end

  #  deterministic
  #  def find_word_by_prefix(prefix, prefix_to_word_map, original_words)
  #    all_words_by_prefix = prefix_to_word_map[prefix]
  #    return nil if all_words_by_prefix == nil || all_words_by_prefix.length == 0
  #    working_word = all_words_by_prefix.shift
  #    original_word = original_words[working_word]
  #    first_word = working_word
  #    while !legal(original_word)
  #      all_words_by_prefix << working_word
  #      working_word = all_words_by_prefix.shift
  #      original_word = original_words[working_word]
  #      if(working_word == first_word)
  #        all_words_by_prefix << working_word
  #        return nil
  #      end
  #    end
  #    all_words_by_prefix << working_word
  #    @illegal_words[original_word] = 1
  #    puts "Illegals: #{@illegal_words.keys.size}, Limbo: #{@legal_limbo.keys.size}"
  #    original_word
  #  end

  def legal(word)
    @illegal_words[word] == nil && @legal_limbo[word] == nil
  end

  # if only one legal word but need to roll it back, it will get picked again straight away
  # causing an infinite loop
  def move_to_legal_limbo(word)
    @illegal_words.delete(word)
    @legal_limbo[word] = 1
  end

  def purge_limbo
    @legal_limbo = {} if @legal_limbo.keys.size > 2000
  end

  #would cause the palindrome to fully roll back eventually as you run out of words, but never return the illegal ones into the pool
  #  def move_to_legal_limbo(word)
  #  end
end