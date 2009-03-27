require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'htmlentities'
require 'iconv'

require File.expand_path(File.dirname(__FILE__) + "/core_extensions")
require File.expand_path(File.dirname(__FILE__) + "/search_result")

class ConsoleSearcher
  attr_reader :name, :terms, :results, :root_url, :href_prefix
  
  def initialize(name, options = {})
    @name = name.to_s
    @coder = HTMLEntities.new
    @root_url = options['root_url'].to_s
    @href_prefix = options['href_prefix'].to_s
    @selector = {}
    ['result', 'link', 'title', 'description'].each do |sel|
      @selector[sel.to_sym] = options['selectors'][sel]
    end
    @options, @terms = ARGV.divide { |term| term =~ /^--(.*)$/; $1 }
    @results = [] 
  end
  
  def option?(name)
    @options.include?(name.to_s)
  end
  
  def self.realm(name)
    yaml = File.read(File.expand_path(File.dirname(__FILE__) + '/../realms.yml'))
    if r = YAML.load(yaml)[name.to_s]
      new(name, r)
    else
      raise "realm not found: #{name}"
    end
  end
  
  def search(&block)
    open(search_url) do |f|
      @page = Hpricot(Iconv.iconv('utf-8', f.charset, f.read).to_s)
    end
    @results = (@page/@selector[:result]).map do |result|
      if href = (result/@selector[:link]).first.attributes['href'] rescue nil
        SearchResult.new(
          :href => href_prefix + href,
          :title => prepare(result.at(@selector[:title])),
          :description => prepare(result.at(@selector[:description]))
        )
      else
        prepare(result)
      end
    end.compact
    self.instance_eval &block
    self
  end
  
  def search_url
    root_url + to_query(terms)
  end
  
  def list
    count = results.size
    results.reverse.each_with_index do |r, i|
      puts "(#{count - i}) " + r.to_s + "\n\n"
    end
    self
  end
  
  private
  
  def prepare(str)
    return '' unless str
    result = @coder.decode(str.inner_html.
      replace_tag(:em) { |keyword| keyword.red }.
      replace_tag(:b) { |keyword| keyword.red }.
      strip_tags
    )
    result.split("\n").map { |part| part.strip }.select { |part| part.length > 0 }.join(' ')
  end
  
  def to_query(terms)
    (terms || []).map { |t| to_param(t) }.join('+')
  end
  
  def to_param(term)
    (term.count(' ') > 0 ? %Q{"#{term}"} : term).url_escape 
  end
end