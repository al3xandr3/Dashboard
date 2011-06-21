
module Dashboard
  
  # http://rosettacode.org/wiki/Multiple_regression#Ruby  
  # http://al3xandr3.github.com/2011/03/18/ml-ex51.html
  # http://rb-gsl.rubyforge.org/files/rdoc/matrix_rdoc.html
  module Regression
    
    class Multi
      require 'gsl'
      include GSL
      attr_accessor :parameters
      
      def initialize y, x, l=0      
        nvars = y.size
        nexamples  = x.size
        # output
        y = Matrix[y.flatten, nvars, 1]
        # data
        x = Matrix[x.transpose.flatten, nvars, nexamples]
 
        # regularization
        d = Matrix.eye(x.size2).set(0,0,0)
  
        @parameters = (x.transpose * x + (l * d)).inv * x.transpose * y
      end
    end
  end
end

#Add to Array 
class Array
  def regression_multi(x=nil, l=0)
    Dashboard::Regression::Multi.new(self, x, l).parameters.to_a
  end
end

if __FILE__ == $0
  require "test/unit"

  class MultiLinearRegressionTest < Test::Unit::TestCase 
    def test1
      x = [[2, 1, 3, 4, 5]]
      y = [1, 2, 3, 4, 5]
      assert_equal([[0.9818181818181818]], 
                   y.regression_multi(x))
    end  

    def test2samples
      x = [[2, 1, 3, 4, 5], 
           [1, 2, 5, 2, 7]]
      y = [1, 2, 3, 4, 5]
      assert_equal([[0.7988904299583913], 
                    [0.16227461858529818]], 
                   y.regression_multi(x))
    end

    def test3
      m = []
      # for each example
      [-0.99768,-0.69574,-0.40373,-0.10236,0.22024,0.47742,0.82229].each do |x|
        # apply full formula
        m << [1, x, x*x, x*x*x, x*x*x*x, x*x*x*x*x]
      end
      x = m.transpose # column=example, row=variable
      y = [2.0885, 1.1646, 0.3287, 0.46013, 0.44808, 0.10013, -0.32952]
      assert_equal([[0.47252877287429573],
                    [0.6813528948564758],
                    [-1.3801284186121974],
                    [-5.977687467468939],
                    [2.441732684793047],
                    [4.737114334830853]], 
                   y.regression_multi(x))
    end  

    def testlambda1
      m = []
      # for each example
      [-0.99768,-0.69574,-0.40373,-0.10236,0.22024,0.47742,0.82229].each do |x|
        # apply full formula
        m << [1, x, x*x, x*x*x, x*x*x*x, x*x*x*x*x]
      end
      x = m.transpose # column=example, row=variable
      y = [2.0885, 1.1646, 0.3287, 0.46013, 0.44808, 0.10013, -0.32952]
      assert_equal([[0.3975952991754666],
                    [-0.420666371376896],
                    [0.1295921119801931],
                    [-0.3974738993914332],
                    [0.17525552670873962],
                    [-0.3393877173623372]], 
                   y.regression_multi(x, 1))
    end  

  end
end
 
