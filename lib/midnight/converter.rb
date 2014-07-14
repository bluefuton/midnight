class Midnight::Converter
  attr_accessor :expr, :tokens

  def convert_tokens_to_cron_expression(tokens)
    @expr = Midnight::CronExpression.new
    @tokens = tokens

    return @expr if @tokens.empty? || tokens.detect { |t| t.type == :special }

    detect_minute_repetition
    detect_hour_repetition
    detect_day_repetition
    detect_weekday_repetition
    detect_week_repetition
    detect_month_repetition
    detect_year_repetition

    #puts tokens.inspect
    @expr
  end

  protected
  def detect_minute_repetition
    @tokens.each do |token|
      if (token.type == :minute_word)
        num_token = tokens.detect { |t| t.type == :number }
        hour_token = tokens.detect { |t| t.type == :hour }
        if num_token.is_a?(Midnight::Token)
          @expr.minute = '*/' + num_token.interval.to_s
        elsif !hour_token.nil?
          @expr.hour = adjust_hour_for_meridiem(hour_token.word)
          @expr.minute = token.word
        elsif @tokens.length == 1  
          @expr.force_run_every_minute = true
        end 
      end

      if (token.type == :minute)
        @expr.minute = token.word
      end
    end
  end

  def detect_hour_repetition
    num_token = tokens.detect { |t| t.type == :number }

    @tokens.each do |token|
      if (token.type == :hour)
        @expr.minute = 0 if @expr.minute.nil?
        num_token = tokens.detect { |t| t.type == :number }
        if num_token.is_a?(Midnight::Token)
          @expr.hour = '*/' + num_token.interval.to_s
        elsif @tokens.length == 1
          @expr.hour = nil
        else
          @expr.hour = adjust_hour_for_meridiem(token.word)
        end 
      end

      if (token.type == :meridiem && !num_token.nil?)
        @expr.hour = adjust_hour_for_meridiem(num_token.word)
      end
    end      
  end

  def detect_week_repetition
    token = @tokens.first

    if (token.type == :week && token.interval == 7)
      @expr.day_of_week = 0
      @expr.hour = 0
      @expr.minute = 0
    end
  end

  def detect_weekday_repetition
    token = @tokens.detect { |t| t.type == :weekday }
    if (!token.nil?)
      @expr.day_of_week = token.position_in_sequence
      if !@tokens.detect { |t| t.type == :minute_word }
        @expr.hour = 0 if @expr.hour.nil?
      end
      @expr.minute = 0 if @expr.minute.nil?
    end
  end    

  def detect_day_repetition
    @tokens.each do |token|
      if (token.type == :day && token.interval == 1)
        @expr.minute = '0'

        # Do we need to run it at a specific time?
        hour_token = tokens.detect { |t| t.type == :number || t.type == :hour }
        if hour_token.is_a?(Midnight::Token)

          hour = hour_token.interval if hour_token.type == :number
          hour = hour_token.word if hour_token.type == :hour

          # Is there a meridiem token (am/pm) too?
          hour = adjust_hour_for_meridiem(hour)

          # Is a minute specified?
          minute_token = tokens.detect { |t| t.type == :minute }
          if minute_token.is_a?(Midnight::Token)          
            @expr.minute = minute_token.word
          end

          @expr.hour = hour
        else
          @expr.hour = 0
        end 
      end
    end
  end

  def detect_month_repetition
    token = @tokens.first
    if (token.type == :month)
      @expr.day_of_month = 1
      @expr.hour = 0
      @expr.minute = 0
    end
  end     

  def detect_year_repetition
    token = @tokens.first
    if (token.type == :year || token.type == :month_name)
      @expr.day_of_month = 1
      @expr.hour = 0
      @expr.minute = 0
      @expr.month = 1
      @expr.month = token.position_in_sequence if token.type == :month_name
    end
  end 

  def adjust_hour_for_meridiem(hour)
    hour = hour.to_i

    # Is there a meridiem token (am/pm)?
    meridiem_token = @tokens.detect { |t| t.type == :meridiem } 

    if (!meridiem_token.nil? && meridiem_token.word == 'pm' && hour < 12)
      hour = hour + 12
    end

    if hour == 24
      hour = 0
    end

    hour
  end
end