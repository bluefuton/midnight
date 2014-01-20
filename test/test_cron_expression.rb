require 'helper'
require 'time'
require 'test/unit'
require './lib/midnight/cron_expression'

class TestParsing < Test::Unit::TestCase

  def setup

  end

  def test_cron_expression
    cron = Midnight::CronExpression.new
    cron.minute = 30
    assert_equal '30 * * * *', cron.to_s
    assert_equal 30, cron.minute
  end
end
