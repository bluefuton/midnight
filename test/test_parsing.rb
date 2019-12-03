require 'helper'
require 'time'
require 'test/unit'

class TestParsing < Test::Unit::TestCase

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
      '7pm every Thursday' => '0 19 * * 4',
      'every May' => '0 0 1 5 *',
      'every December' => '0 0 1 12 *',
      'midnight' => '0 0 * * *',
      'midnight on tuesdays' => '0 0 * * 2',
      'every 5 minutes on Tuesdays' => '*/5 * * * 2',
      'every other day' => nil, # other is currently unsupported
      'noon' => '0 12 * * *',
      'midnight on weekdays' => '0 0 * * 1-5'
    }

    expected_results.each do |search,cron_string|
      assert_equal(cron_string, Midnight.parse(search).to_s, search)
    end
  end

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
