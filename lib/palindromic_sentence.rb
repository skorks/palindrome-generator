class PalindromicSentence
  def initialize(front, back)
    @front_array = front
    @back_array = back

    @front_string = array_as_string(@front_array)
    @back_string = array_as_string(@back_array)
    @reverse_back_string = @back_string.reverse
    @undo_stack = []
  end

  def array_as_string(array)
    array.join("").downcase.gsub(/\s*/, '')
  end

  def palindrome?
    string = @front_string + @back_string
    string == string.reverse
  end

  def perfect_palindrome?
    palindrome? && @front_string.size == @back_string.size
  end

  def size
    @front_array.length + @back_array.length
  end

  def to_s
    @front_array.join(", ") + ", " + @back_array.join(", ")
  end

  def needs_word_at_front?
    @reverse_back_string.length > @front_string.length
  end

  def current_difference
    if needs_word_at_front?
      difference_size = @reverse_back_string.length - @front_string.length
      @reverse_back_string[@front_string.length, difference_size]
    else
      difference_size = @front_string.length - @reverse_back_string.length
      @front_string[@reverse_back_string.length, difference_size]
    end
  end

  def roll_back
    word = @undo_stack.last
    clean_word = word.downcase.gsub(/\s*/, '')
    @undo_stack.delete(word)

    if @front_array.last == word
      @front_array.delete(word)
      @front_string = @front_string[0, @front_string.length - clean_word.length]
    else
      @back_array.shift
      @back_string = @back_string[clean_word.length, @back_string.length - clean_word.length]
      @reverse_back_string = @reverse_back_string[0, @reverse_back_string.length - clean_word.length]
    end
    word
  end

  def add_word(word)
    if needs_word_at_front?
      add_front(word)
    else
      add_back(word)
    end
  end

  def add_front(word)
    @front_array << word
    clean_word = word.downcase.gsub(/\s*/, '')
    @front_string = @front_string + clean_word
    @undo_stack << word
  end

  def add_back(word)
    @back_array.unshift(word)
    clean_word = word.downcase.gsub(/\s*/, '')
    @back_string = clean_word + @back_string
    @reverse_back_string = @reverse_back_string + clean_word.reverse
    @undo_stack << word
  end

  def current_stack
    #    puts to_s.downcase.inspect
    #    puts @front_string
    #    puts @reverse_back_string
    #    @undo_stack.inspect
    size
  end
end