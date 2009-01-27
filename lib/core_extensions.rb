class String
  def strip_tags
    self.gsub(/<[^<>]+>/,'')
  end
  
  def replace_tag(tag, &block)
    self.gsub(/<#{tag}>([^<>]+)<\/#{tag}>/) { |match| yield $1 }
  end
  
  def url_escape
    self.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
    '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end
  
  def green
    "\033[0;32m" + self + "\033[0m"
  end

  def red
    "\033[0;31m" + self + "\033[0m"
  end

  def yellow
    "\033[0;33m" + self + "\033[0m"
  end
  
  def with_line_length(max_length)
    words = split(' ')
    result = []
    line = []
    words.each do |w|
      line << w
      if line.join(' ').length >= max_length
        result << line.join(' ')
        line = []
      end
    end
    result << line.join(' ') unless line.empty?
    result
  end
end

class Array
  def divide(&block)
    a = []
    b = []
    self.each do |item|
      v = yield item
      v ? (a << v) : (b << item)
    end
    [a, b]
  end
end