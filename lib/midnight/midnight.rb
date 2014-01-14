require_relative "../numerizer/numerizer.rb"

module Midnight
  class << self

    def parse(text, specified_options = {})
      # get options and set defaults if necessary
      default_options = {:start => Time.now}
      options = default_options.merge specified_options

      # ensure the specified options are valid
      specified_options.keys.each do |key|
        default_options.keys.include?(key) || raise(InvalidArgumentException, "#{key} is not a valid option key.")
      end
      Chronic.parse(specified_options[:start]) || raise(InvalidArgumentException, ':start specified is not a valid datetime.') if specified_options[:start]

      # remove every is specified
      text = text.gsub(/^every\s\b/, '')

      # put the text into a normal format to ease scanning using Chronic
      text = pre_normalize(text)
      text = Chronic::Parser.new.pre_normalize(text)
      text = numericize_ordinals(text)

      # check to see if this event starts some other time and reset now
      event, starting = text.split('starting')
      @start = (Chronic.parse(starting) || options[:start])
      @next = nil

      # split into tokens
      @tokens = base_tokenize(event)

      # scan the tokens with each token scanner
      @tokens = Repeater.scan(@tokens)

      # remove all tokens without a type
      @tokens.reject! {|token| token.type.nil? }

      cron_expression = self.convert_tokens_to_cron_expression(@tokens)

      return cron_expression
    end

    # Normalize natural string removing prefix language
    def pre_normalize(text)
      normalized_text = text.gsub(/^every\s\b/, '')
      normalized_text = text.gsub(/^each\s\b/, '')
      normalized_text = text.gsub(/^on the\s\b/, '')
      normalized_text
    end

    # Split the text on spaces and convert each word into
    # a Token
    def base_tokenize(text) #:nodoc:
      text.split(' ').map { |word| Token.new(word) }
    end

    # Convert ordinal words to numeric ordinals (third => 3rd)
    def numericize_ordinals(text) #:nodoc:
      text = text.gsub(/\b(\d*)(st|nd|rd|th)\b/, '\1')
    end

    # Returns an array of types for all tokens
    def token_types
      @tokens.map(&:type)
    end

    def convert_tokens_to_cron_expression(tokens)
      expr = CronExpression.new
      tokens.each do |token|
        # Daily
        if (token.type == :day && token.interval == 1)
          expr.minute = '0'

          # Do we need to run it at a specific time?
          hour_token = tokens.detect { |t| t.type == :number }
          if hour_token.is_a?(Token)
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
          if num_token.is_a?(Token)
            expr.minute = '*/' + num_token.interval.to_s
          else
            expr.force_run_every_minute = true
          end 
        end
      end
      #puts tokens.inspect
      expr
    end
  end

  class Token #:nodoc:
    attr_accessor :word, :type, :interval, :start, :position_in_sequence

    def initialize(word)
      @word = word
      @type = @interval = @start = nil
    end

    def update(type, start=nil, interval=nil, position_in_sequence=nil)
      @start = start
      @type = type
      @interval = interval
      @position_in_sequence = position_in_sequence
    end
  end

  # This exception is raised if an invalid argument is provided to
  # any of Midnight's methods
  class InvalidArgumentException < Exception

  end
end
