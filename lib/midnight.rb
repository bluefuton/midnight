#=============================================================================
#
#  Name:       Midnight
#  Author:     Chris Rosser
#  Purpose:    Parse natural language date/time into a cron expression
#
#=============================================================================

$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

require 'date'
require 'time'
require 'chronic'

require 'midnight/midnight'
require 'midnight/handler'
require 'midnight/repeater'
require 'midnight/cron_expression'
require 'midnight/converter'
require 'midnight/version'

module Midnight
  def self.debug; false; end

  def self.dwrite(msg)
    puts msg if Midnight.debug
  end
end

class Date
   def days_in_month
     d,m,y = mday,month,year
     d += 1 while Date.valid_civil?(y,m,d)
     d - 1
   end
end

class Array
  def same?(y)
    self.sort == y.sort
  end
end
