#! /usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + "/lib/console_searcher")

ConsoleSearcher.realm(:google).search do
  `open #{@results.first.href}` if option?(:lucky)
  list
  puts search_url
end