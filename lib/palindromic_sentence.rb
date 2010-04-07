class PalindromicSentence
  def initialize(front, back)
    @front_array = front
    @back_array = back

    @front_string = array_as_string(@front_array).downcase.gsub(/\s/, "")
    @back_string = array_as_string(@back_array).downcase.gsub(/\s/, "")
    @reverse_back_string = @back_string.reverse
    @undo_stack = []
  end

  def current_difference
    if add_to_front?
      difference_size = @reverse_back_string.length - @front_string.length
      @reverse_back_string[@front_string.length, difference_size]
    else
      difference_size = @front_string.length - @reverse_back_string.length
      @front_string[@reverse_back_string.length, difference_size]
    end
  end

  def add_to_front?
    @reverse_back_string.length > @front_string.length
  end

  def add_to_back?
    @reverse_back_string.length < @front_string.length
  end

  def needs_rollback?
    @reverse_back_string.length == @front_string.length
  end

  def add_word(word)
    if add_to_front?
      add_front(word)
    else
      add_back(word)
    end
  end

  def reverse_word?
    return add_to_back?
  end

  def add_front(word)
    @front_array << word
    clean_word = word.gsub(/\s/, '')
    @front_string = @front_string + clean_word
    @undo_stack << word
  end

  def add_back(word)
    @back_array.unshift(word)
    clean_word = word.gsub(/\s/, '')
    @back_string = clean_word + @back_string
    @reverse_back_string = @reverse_back_string + clean_word.reverse
    @undo_stack << word
  end

  def roll_back
    word = @undo_stack.last
    clean_word = word.gsub(/\s/, '')
    @undo_stack.delete(word)

    if @front_array.last == word
      @front_array.delete(word)
      @front_string = @front_string[0, @front_string.length - clean_word.length]
    else
      @back_array.shift
      @back_string = @back_string[clean_word.length, @back_string.length - clean_word.length]
      @reverse_back_string = @reverse_back_string[0, @reverse_back_string.length - clean_word.length]
    end
  end

  def current_stack
    @undo_stack.inspect
  end

  def palindrome?
    string = @front_string + @back_string
    string == string.reverse
  end

  def size
    @front_array.length + @back_array.length
  end

  def to_s
    @front_array.join(" ") + " " + @back_array.join(" ")
  end

  def array_as_string(array)
    array.join(" ").gsub(/\s/, '')
  end
end