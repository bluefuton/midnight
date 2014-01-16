class Midnight::Converter
	def self.convert_tokens_to_cron_expression(tokens)
	  expr = Midnight::CronExpression.new
	  tokens.each do |token|
	    # Daily
	    if (token.type == :day && token.interval == 1)
	      expr.minute = '0'

	      # Do we need to run it at a specific time?
	      hour_token = tokens.detect { |t| t.type == :number }
	      if hour_token.is_a?(Midnight::Token)
	        expr.hour = hour_token.interval
	      else
	        expr.hour = 0
	      end 
	    end
	  
	    # Weekly
	    if (token.type == :week && token.interval == 7)
	      expr.day_of_week = 0
	      expr.hour = 0
	      expr.minute = 0
	    end

	    # Monthly
	    if (token.type == :month)
	      expr.day_of_month = 1
	      expr.hour = 0
	      expr.minute = 0
	    end

	    # Weekday
	    if (token.type == :weekday)
	      expr.day_of_week = token.position_in_sequence
	      expr.hour = 0
	      expr.minute = 0
	    end

	    # Minute
	    if (token.type == :minute)
	      num_token = tokens.detect { |t| t.type == :number }
	      if num_token.is_a?(Midnight::Token)
	        expr.minute = '*/' + num_token.interval.to_s
	      else
	        expr.force_run_every_minute = true
	      end 
	    end

	    # Hour
	    if (token.type == :hour)
	      expr.minute = 0
	      num_token = tokens.detect { |t| t.type == :number }
	      if num_token.is_a?(Midnight::Token)
	        expr.hour = '*/' + num_token.interval.to_s
	      end 
	    end        
	  end
	  #puts tokens.inspect
	  expr
	end
end