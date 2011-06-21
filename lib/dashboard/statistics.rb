
# append to enumerable
module Enumerable

  def frequency
    self.inject(Hash.new(0)) { |h, x| h[x] += 1; h}
  end
  
  def absolute_change
    idx = self.first
    self.collect { |v|
      (v.to_f/idx)*100
    }
  end

  def relative_change
    idx = self.first
    self.collect { |v|
      ((v.to_f-idx)/idx)*100
    }
  end

  def sum
    return self.inject(0){|acc,i| acc + i}
  end
 
  def average
    return self.sum/self.length.to_f
  end

  # variance of sample
  def variance
    avg=self.average
    sum=self.inject(0){|acc,i| acc + (i-avg)**2 }
    return(1/(self.length.to_f-1)*sum)
  end

  # sd of sample
  def sd
    return Math.sqrt(self.variance)
  end

  # assume full population
  def variance_population
    # for example of a dice
    avg=self.average
    sum=self.inject(0){|acc,i| acc + (i-avg)**2 }
    return(1/self.length.to_f*sum)
  end

  # assume full population
  def sd_population
    # for example of a dice
    return Math.sqrt(self.variance_population)
  end

end

if __FILE__ == $0
  require "test/unit"
  class TestAlenum < Test::Unit::TestCase 
    def test_relative_change
      assert_equal [100.0,200.0,50.0,400.0,500.0,600.0,700.0,800.0,900.0], 
                   [1,2,0.5,4,5,6,7,8,9].absolute_change
      
      assert_equal [100.0,186.95652173913044,21.73913043478261], 
                   [2.3,4.3,0.5].absolute_change
    end

    def test_sum
      assert_equal 42.5, [1,2,0.5,4,5,6,7,8,9].sum
      assert_equal    6, [1,2,3].sum
    end

    def test_average
      assert_equal 4.722222222222222, [1,2,0.5,4,5,6,7,8,9].average
      assert_equal 3.5,               [1,2,3,4,5,6].average
    end

    def test_variance
      assert_equal 9.444444444444445, [1,2,0.5,4,5,6,7,8,9].variance
      assert_equal 3.5,               [1,2,3,4,5,6].variance
    end
    
    def test_sd
      assert_equal 3.073181485764296,  [1,2,0.5,4,5,6,7,8,9].sd
      assert_equal 1.8708286933869707, [1,2,3,4,5,6].sd
    end

    def test_variance_real
      assert_equal 8.395061728395062,  [1,2,0.5,4,5,6,7,8,9].variance_population
      assert_equal 2.9166666666666665, [1,2,3,4,5,6].variance_population
    end
    def test_sd_real
      assert_equal 2.8974232912011773, [1,2,0.5,4,5,6,7,8,9].sd_population
      assert_equal 1.707825127659933,  [1,2,3,4,5,6].sd_population
    end

    def test_frequency
      assert_equal({1=>1, 2=>3, 3=>1, 4=>1}, [1,2,2,3,2,4].frequency)
    end

  end
end
