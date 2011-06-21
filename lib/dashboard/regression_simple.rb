

module Dashboard

  module Regression

    class Simple
      attr_accessor :slope, :offset

      def initialize dy, dx=nil
        @size = dy.size
        dx = axis() unless dx  # make 2D if given 1D
        raise "arguments not same length!" unless @size == dy.size
        sxx = sxy = sx = sy = 0.0
        dx.zip(dy).each do |x,y|
          sxy += x*y
          sxx += x*x
          sx  += x
          sy  += y
        end 
        @slope = ((@size*sxy) - sx*sy) / ((@size*sxx) - (sx*sx))
        @offset = (sy - (@slope*sx)) / @size
      end
    
      def fit
        return axis.map{|data| predict(data) }
      end
    
      def predict( x )
        y = @slope * x + @offset
      end
    
      def axis
        (0...@size).to_a
      end
    end
  end
end

#Add to Array 
class Array
  def regression_simple(x=nil)
    Dashboard::Regression::Simple.new self, x
  end
end


if __FILE__ == $0
  require "test/unit"
  class SimpleLinearRegressionTest < Test::Unit::TestCase 
    def test1
      x = [60,61,62,63,65]
      y = [3.1,3.6,3.8,4,4.1]
      lr = Dashboard::Regression::Simple.new y, x
      assert_equal 0.18783783783783292, lr.slope
      assert_equal -7.963513513513208, lr.offset
    end
    
    def test2
      x = [1,2,3,4,5,6,7]
      y = [5,1,3,7,10,3,5] 
      lr = Dashboard::Regression::Simple.new y, x
      assert_equal 0.39285714285714285, lr.slope
      assert_equal 3.2857142857142856, lr.offset
    end
    
    def test3
      x = [0,1,2,3,4,5,6]
      y = [5,1,3,7,10,3,5] 
      lr = Dashboard::Regression::Simple.new y, x
      assert_equal 0.39285714285714285, lr.slope
      assert_equal 3.6785714285714284, lr.offset
    end
    
    def test4
      y = [5,1,3,7,10,3,5] 
      lr = Dashboard::Regression::Simple.new y
      assert_equal 0.39285714285714285, lr.slope
      assert_equal 3.6785714285714284, lr.offset
    end

    def test5
      y = [5,1,3,7,10,3,5] 
      lr = Dashboard::Regression::Simple.new y
      assert_equal [3.6785714285714284,4.071428571428571,
                    4.464285714285714, 4.857142857142857,
                    5.25, 5.642857142857142, 
                    6.035714285714286], lr.fit
      assert_equal 4.464285714285714, lr.predict(2)
    end

    def test_ArrayIntegration
      y = [5,1,3,7,10,3,5] 
      lr = y.regression_simple
      assert_equal 0.39285714285714285, lr.slope
      assert_equal 3.6785714285714284,  lr.offset
    end

    def test_ArrayIntegration2
      x = [0,1,2,3,4,5,6]
      y = [5,1,3,7,10,3,5] 
      lr = y.regression_simple x
      assert_equal 0.39285714285714285, lr.slope
      assert_equal 3.6785714285714284,  lr.offset
    end

  end
end
 
