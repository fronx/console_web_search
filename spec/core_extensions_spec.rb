require 'spec'
require File.dirname(__FILE__) + "/../lib/core_extensions"

describe 'Array' do
  
  describe "(with_index)" do
    it "should give each element an index method" do
      [:a, :b, :c].with_index.map { |i| i.index }.should == [0, 1, 2]
      :x.index.should == nil
    end
  end
  
  describe "(connect)" do
    it "should return a hash" do
      ['a', 'b', 'c'].connect([:b, :c, :a]) { |a, b|
        a.to_sym == b
      }.should == {'a' => :a, 'b' => :b, 'c' => :c}
    end
  end
end