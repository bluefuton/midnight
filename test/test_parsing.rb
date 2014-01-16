require 'helper'
require 'time'
require 'test/unit'

class TestParsing < Test::Unit::TestCase

  def setup

  end

  def test_parse
    expected_results = {
      'each day' =>  '0 0 * * *',
      'every day' =>  '0 0 * * *',
      'daily' => '0 0 * * *',
      'every day at 3am' => '0 3 * * *',
      'daily at 5am' => '0 5 * * *',
      'every week' => '0 0 * * 0',
      'weekly' => '0 0 * * 0',
      'every minute' => '* * * * *',
      'every 5 minutes' => '*/5 * * * *',
      'every 30 minutes' => '*/30 * * * *',
      'every month' => '0 0 1 * *',
      'monthly' => '0 0 1 * *',
      'every Monday' => '0 0 * * 1',
      'every Wednesday' => '0 0 * * 3',
      'every Friday' => '0 0 * * 5',
      'this one should not return a result' => nil,
      'every hour' => '0 * * * *',
      'every 6 hours' => '0 */6 * * *',
      'hourly' => '0 * * * *',
      'every year' => '0 0 1 1 *',
      'yearly' => '0 0 1 1 *',
      'annually' => '0 0 1 1 *',
      'every day at 9am' => '0 9 * * *',
      'every day at 5pm' => '0 17 * * *',
      'every day at 5:45pm' => '45 17 * * *',      
      'every day at 17:00' => '0 17 * * *',
      'every day at 17:25' => '25 17 * * *',
      '5:15am every Tuesday' => '15 5 * * 2',
      '7pm every Thursday' => '0 19 * * 4'
    }

    expected_results.each do |search,cron_string|
      assert_equal(cron_string, Midnight.parse(search).to_s, search)
    end
  end

  # def test_parse_best_guess
  #   parse_now('every 3 days')
  #   parse_now('every 3 weeks')
  #   parse_now('every 3 months')
  #   parse_now('every 3 years')

  #   parse_now('every other day')
  #   parse_now('every other week')
  #   parse_now('every other month')
  #   parse_now('every other year')
  #   parse_now('every other day starting May 1st')
  #   parse_now('every other week starting this Sunday')
  #   
  #   parse_now('every May')
  #   parse_now('every june')

  #   parse_now('beginning of the week')
  #   parse_now('middle of the week')
  #   parse_now('end of the week')

  #   parse_now('beginning of the month')
  #   parse_now('middle of the month')
  #   parse_now('end of the month')

  #   parse_now('beginning of the year')
  #   parse_now('middle of the year')
  #   parse_now('end of the year')

  #   parse_now('the 10th of the month')
  #   parse_now('the tenth of the month')
  #   parse_now('the 3rd Sunday of the month')
  #   5am every Tuesday
  #   out of bounds values e.g. 4:61pm
  # end

  def test_argument_validation
    assert_raise(Midnight::InvalidArgumentException) do
      time = Midnight.parse("may 27", :today => 'something odd')
    end

    assert_raise(Midnight::InvalidArgumentException) do
      time = Midnight.parse("may 27", :foo => :bar)
    end
  end

  private
  def parse_now(string, options={})
    out = Midnight.parse(string, {}.merge(options))
    puts ("Midnight.parse('#{string}')  #=> #{out}")
    out
  end
end
