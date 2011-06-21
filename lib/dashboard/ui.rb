
class Numeric
  def commify(dec='.', sep=',')
    num = to_s.sub(/\./, dec)
    dec = Regexp.escape dec
    num.reverse.gsub(/(\d\d\d)(?=\d)(?!\d*#{dec})/, "\\1#{sep}").reverse
  end

  def alert_higher_than(ideal, tolerance=0.30)
    tr = ideal + (ideal*tolerance)    
    return "good"    if self < ideal
    return "soso"    if self > ideal and self < tr
    return "notgood" if self > tr
  end

  def alert_lower_than(ideal, tolerance=0.02)
    tr = ideal - (ideal*tolerance)  
    return "good" if self > ideal  
    return "soso" if self < ideal and self > tr
    return "notgood" if self < tr
  end

end

if __FILE__ == $0
  require "test/unit"
  class UITest < Test::Unit::TestCase 
    def testCommify
      assert_equal "1,000", 1000.commify
      assert_equal "12,312,312.23", (12312312.23).commify
    end

    def testAlertHigher
      assert_equal "soso",    12.alert_higher_than(10)
      assert_equal "notgood", 15.alert_higher_than(10)
      assert_equal "good",    8.alert_higher_than(10)
    end

    def testAlertLower
      assert_equal "notgood", 95.alert_lower_than(99)
      assert_equal "soso",    98.alert_lower_than(99)
      assert_equal "good",   100.alert_lower_than(99)
    end

  end
end
