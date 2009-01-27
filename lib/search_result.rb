class SearchResult
  attr_reader :href, :title, :description
  
  def initialize(options = {})
    @href = options[:href]
    @title = options[:title]
    @description = options[:description]
  end
  
  def to_s(indent = 4)
    indent = "\n" + ' ' * indent
    [title, href.green, description.with_line_length(50).join(indent)].join(indent)
  end
end