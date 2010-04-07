require 'dictionary'
require 'palindromic_sentence'
require 'palindrome_generator'

dictionary = Dictionary.new("/usr/share/dict/words")

#dictionary = Dictionary.new("/home/wpol/tmp/npdict.txt")

generator = PalindromeGenerator.new(dictionary)
generator.generate(300, :watch_stack => true)
