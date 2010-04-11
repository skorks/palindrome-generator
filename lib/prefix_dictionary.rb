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
  def self.clean_word_regex
    /[^a-z0-9]/
  end
  
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

    #    puts total_values_for_prefixes(@prefix_to_word)

    #find all possible prefixes that start with this word
    all_prefixes = @prefix_to_word.keys.sort

    #    count = 0
    @original_words.keys.each do |word|
      prefixes_for_word_range = all_prefixes.bsearch_range do |existing_prefix| 
        existing_prefix[0, word.length] <=> word
      end
      next if prefixes_for_word_range.begin == prefixes_for_word_range.end
      prefixes_for_word_range.each do |index|
        #        puts "Prefix: #{all_prefixes[index]}, Word: #{word}" if count < 100
        @prefix_to_word[all_prefixes[index]] << word
        #        count += 1
      end
    end

    #find all possible prefixes that start with this word
    all_prefixes_reversed = @prefix_to_word_reversed.keys.sort

    #    count = 0
    @original_words_reverse_keys.keys.each do |word|
      prefixes_for_word_range = all_prefixes_reversed.bsearch_range do |existing_prefix|
        existing_prefix[0, word.length] <=> word
      end
      next if prefixes_for_word_range.begin == prefixes_for_word_range.end
      prefixes_for_word_range.each do |index|
        #        puts "Prefix: #{all_prefixes[index]}, Word: #{word}" if count < 100
        @prefix_to_word_reversed[all_prefixes_reversed[index]] << word
        #        count += 1
      end
    end

    #    puts total_values_for_prefixes(@prefix_to_word)

    #    exit

    
    @palindrome_pairs = []
    @front_centric_larger_to_smaller_palindromic_words = []
    @back_centric_larger_to_smaller_palindromic_words = []
   
    @palindrome_pairs = find_palindrome_pairs
    @front_centric_larger_to_smaller_palindromic_words = find_front_centric_larger_to_smaller_palindromic_words
    @back_centric_larger_to_smaller_palindromic_words = find_back_centric_larger_to_smaller_palindromic_words
    puts @front_centric_larger_to_smaller_palindromic_words.length
    puts @back_centric_larger_to_smaller_palindromic_words.length
  end

  def find_legal_back_centric_larger_to_smaller_palindromic_pair
    @back_centric_larger_to_smaller_palindromic_words.each do |item|
      original_container = item[:original_container]
      original_word = item[:original_word]
      if legal(original_container) && legal(original_word)
        @illegal_words[original_container] = 1
        @illegal_words[original_word] = 1
        return [original_container, original_word]
      end
    end
    nil
  end

  def legal_palindrome_pairs
    legal_pairs = []
    @palindrome_pairs.each do |pair|
      if legal(pair[0]) && legal(pair[1])
        @illegal_words[pair[0]] = 1
        @illegal_words[pair[1]] = 1
        legal_pairs << pair
      end
    end
    legal_pairs
  end

  def total_values_for_prefixes(prefix_hash)
    total = 0
    prefix_hash.keys.each do |key|
      next if prefix_hash[key] == nil
      total += prefix_hash[key].length
    end
    total
  end

  #find all words that can be added to front of palindrome where there is a SMALLER word that can be added at the back and
  #it will still be possible to find another word to continue the palindrome
  def find_front_centric_larger_to_smaller_palindromic_words
    front_centric_larger_to_smaller_palindromic_words = []
    @original_words.keys.each do |working_word|
      working_word_reversed = working_word.reverse
      if working_word_reversed.length > 3
        all_words_containing_word_palindromically = find_all_words_starting_with(working_word_reversed)
        if all_words_containing_word_palindromically != nil
          all_words_containing_word_palindromically.each do |array_word|
            suffix = array_word[working_word_reversed.length, array_word.length - working_word_reversed.length]
            if find_all_words_reverse_starting_with(suffix) != nil
              #              puts "Palindromically: Word: #{working_word}, Reversed: #{working_word_reversed}, Container: #{array_word}, Original(w):#{@original_words[working_word]}, Original(c): #{@original_words[array_word]}, Suffix: #{suffix}"
              front_centric_larger_to_smaller_palindromic_words << {:working_word => working_word, :working_word_reversed => working_word_reversed,
                :container_word => array_word, :original_word => @original_words[working_word], :original_container => @original_words[array_word], :suffix => suffix
              }
            end
          end
        end
      end
    end
    front_centric_larger_to_smaller_palindromic_words
  end

  #find all words that can be added to the back of palindrome where there is a smaller word that can be added to the front and
  #it will still be possible to find another word to continue the palindrome
  def find_back_centric_larger_to_smaller_palindromic_words
    back_centric_larger_to_smaller_palindromic_words = []
    @original_words_reverse_keys.keys.each do |working_word_reversed|
      working_word = working_word_reversed.reverse
      if working_word.length > 3
        all_words_containing_word_palindromically = find_all_words_reverse_starting_with(working_word)
        if all_words_containing_word_palindromically != nil
          all_words_containing_word_palindromically.each do |array_word|
            suffix = array_word[working_word.length, array_word.length - working_word.length]
            if find_all_words_starting_with(suffix) != nil
              #              puts "Palindromically: Reversed: #{working_word_reversed}, Word: #{working_word}, Container: #{array_word}, Original(w): #{@original_words_reverse_keys[working_word_reversed]}, Original(c): #{@original_words_reverse_keys[array_word]}, Suffix: #{suffix}"
              back_centric_larger_to_smaller_palindromic_words << {:working_word => working_word_reversed, :working_word_reversed => working_word,
                :container_word => array_word, :original_word => @original_words_reverse_keys[working_word_reversed],
                :original_container => @original_words_reverse_keys[array_word], :suffix => suffix
              }
            end
          end
        end
      end
    end
    back_centric_larger_to_smaller_palindromic_words
  end

  def find_all_words_starting_with(prefix)
    all_words_by_prefix = @prefix_to_word[prefix]
    return nil if all_words_by_prefix == nil || all_words_by_prefix.length == 0
    all_words_by_prefix.delete(prefix)
    all_words_by_prefix
  end

  def find_all_words_reverse_starting_with(prefix)
    all_words_by_prefix = @prefix_to_word_reversed[prefix]
    return nil if all_words_by_prefix == nil || all_words_by_prefix.length == 0
    all_words_by_prefix.delete(prefix)
    all_words_by_prefix
  end

  #find all words that are palindromes of each other
  #can insert all these in one big bang when we get the first perfect palindrome
  def find_palindrome_pairs
    palindrome_pairs = []
    @original_words.keys.each do |word|
      original_word = @original_words[word]
      original_word_palindrome = @original_words[word.reverse]
      if original_word_palindrome != nil && original_word != original_word_palindrome
        #        puts "Palindrome pair: #{@original_words[word]}:#{@original_words[word.reverse]}"
        palindrome_pairs << [original_word, original_word_palindrome]
      end
    end
    palindrome_pairs
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
      working_word = real_word.downcase.gsub(PrefixDictionary.clean_word_regex, "")
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


  #  #non-deterministic 2
  #  def find_word_by_prefix(prefix, prefix_to_word_map, original_words)
  #    all_words_by_prefix = prefix_to_word_map[prefix]
  #    return nil if all_words_by_prefix == nil || all_words_by_prefix.length == 0
  #    all_words_by_prefix = all_words_by_prefix.shuffle
  #    all_words_by_prefix.each do |working_word|
  #      original_word = original_words[working_word]
  #      if legal(original_word)
  #        @illegal_words[original_word] = 1
  #        puts "Illegals: #{@illegal_words.keys.size}, Limbo: #{@legal_limbo.keys.size}"
  #        return original_word
  #      end
  #    end
  #    nil
  #  end

  #non-deterministic
  def find_word_by_prefix(prefix, prefix_to_word_map, original_words)
    all_words_by_prefix = prefix_to_word_map[prefix]
    temp_array = []
    return nil if all_words_by_prefix == nil || all_words_by_prefix.length == 0
    rand_index = rand(all_words_by_prefix.length - 1)
    working_word = all_words_by_prefix.delete_at(rand_index)
    original_word = original_words[working_word]
    temp_array << working_word
  
    while !legal(original_word)
      return nil if all_words_by_prefix.length == 0
      rand_index = rand(all_words_by_prefix.length - 1)
      working_word = all_words_by_prefix.delete_at(rand_index)
      original_word = original_words[working_word]
      temp_array << working_word
    end
    @illegal_words[original_word] = 1
    prefix_to_word_map[prefix] = all_words_by_prefix + temp_array
    puts "Illegals: #{@illegal_words.keys.size}, Limbo: #{@legal_limbo.keys.size}"
    original_word
  end

  #  #    deterministic
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
    @legal_limbo = {} if @legal_limbo.keys.size > 1500
  end

  #would cause the palindrome to fully roll back eventually as you run out of words, but never return the illegal ones into the pool
  #  def move_to_legal_limbo(word)
  #  end
end