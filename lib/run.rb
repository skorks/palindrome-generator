require 'dictionary'
require 'palindromic_sentence'
require 'palindrome_generator'
require 'bsearch'
require 'prefix_dictionary'
require 'profiler'

#dictionary = Dictionary.new("/usr/share/dict/words")

#dictionary = Dictionary.new("/home/alan/tmp/npdict.txt")
#
#generator = PalindromeGenerator.new(dictionary)
#generator.generate(1000, :watch_stack => true)

#dictionary = Dictionary.new("/home/alan/tmp/npdict.txt")

#dictionary = PrefixDictionary.new("/usr/share/dict/words")
dictionary = PrefixDictionary.new("/home/alan/tmp/npdict.txt")
generator = PalindromeGenerator.new(dictionary, :watch_stack => true, :output_file => "/home/alan/tmp/palindromes.txt")
generator.generate(20000)
