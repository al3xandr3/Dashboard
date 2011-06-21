module Dashboard #:nodoc:
  VERSION = "0.1"
end

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require "dashboard/statistics"
require "dashboard/chart"
require "dashboard/regression_simple"
require "dashboard/regression_multi"
require "dashboard/mail"
require "dashboard/confluence"
require "dashboard/ui"
