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

  def blue
    "\033[0;34m" + self + "\033[0m"
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

  def split(&block)
    matches, non_matches = [], []
    self.each_with_index do |item, index|
      (yield(item, index) ? matches : non_matches) << item
    end
    [matches, non_matches]
  end

  def connect(other, &block)
    result = {}
    self.with_index.each do |a|
      other.with_index.detect do |b|
        result[a] = b if yield(a, b)
      end
    end
    result
  end

  def with_index
    result = self.dup
    result.each_with_index do |item, index|
      item.instance_variable_set('@index', index)
      item.class.instance_eval do
        define_method :index do
          instance_variable_get('@index')
        end
      end
    end
    result
  end
end

class Integer
  def limit(n)
    self > n ? n : self
  end
end