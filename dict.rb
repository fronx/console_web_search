#! /usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + "/lib/console_searcher")

def clean(word)
  word.
    gsub(/^\d+/,'').
    gsub(/\{.+\}/,'').
    gsub(/\[.+\]/,'').
    gsub(/[ ]+/,' ').
    strip
end

ConsoleSearcher.realm(:dict).search do
  english, german = results.split { |word, index| index % 2 == 0 }.map { |word_list| word_list.reverse }
  lwidth = english.max { |a, b| a.length <=> b.length }.length.limit(30) rescue 0
  english.each_with_index do |en, index|
    en = clean(en).rjust(lwidth)
    puts en << ' => ' << clean(german[index])
  end
  puts; puts search_url
end