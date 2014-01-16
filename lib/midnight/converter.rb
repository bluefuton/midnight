class Midnight::Converter
  attr_accessor :expr, :tokens

  def convert_tokens_to_cron_expression(tokens)
    @expr = Midnight::CronExpression.new
    @tokens = tokens

    return @expr if @tokens.empty?

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
      if (token.type == :minute && @tokens.length <= 2)
        num_token = tokens.detect { |t| t.type == :number }
        if num_token.is_a?(Midnight::Token)
          @expr.minute = '*/' + num_token.interval.to_s
        else
          @expr.force_run_every_minute = true
        end 
      end
    end
  end

  def detect_hour_repetition
    @tokens.each do |token|
      if (token.type == :hour)
        @expr.minute = 0
        num_token = tokens.detect { |t| t.type == :number }
        if num_token.is_a?(Midnight::Token)
          @expr.hour = '*/' + num_token.interval.to_s
        end 
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
    token = @tokens.first
    if (token.type == :weekday)
      @expr.day_of_week = token.position_in_sequence
      @expr.hour = 0
      @expr.minute = 0
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
          meridiem_token = tokens.detect { |t| t.type == :meridiem } 

          if (!meridiem_token.nil? && meridiem_token.word == 'pm')
            hour = hour + 12
          end

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
    if (token.type == :year)
      @expr.day_of_month = 1
      @expr.hour = 0
      @expr.minute = 0
      @expr.month = 1
    end
  end 
end