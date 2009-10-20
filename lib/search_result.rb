class SearchResult
  attr_reader :href, :title, :description
  
  def initialize(options = {})
    @href = options[:href]
    @title = options[:title]
    @description = options[:description]
  end
  
  def to_s(indent = 4)
    indent = "\n" + ' ' * indent
    [
      title.red,
      if href.to_s.strip.length > 0
        href.green
      end,
      description.with_line_length(50).join(indent)
    ].compact.join(indent)
  end
end
