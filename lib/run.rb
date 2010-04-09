require 'dictionary'
require 'palindromic_sentence'
require 'palindrome_generator'
require 'bsearch'

def test_dictionary(dict)
#  puts dict.find_word_starting_with("cra")
  puts dict.find_word_reverse_starting_with("bou")
end

dictionary = Dictionary.new("/usr/share/dict/words")

#dictionary = Dictionary.new("/home/wpol/tmp/npdict.txt")

generator = PalindromeGenerator.new(dictionary)
generator.generate(1000, :watch_stack => true)


#test_dictionary(dictionary)
