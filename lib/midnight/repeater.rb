class Midnight::Repeater < Chronic::Tag #:nodoc:
  #
  def self.scan(tokens)
    # for each token
    tokens.each do |token|
      token = self.scan_for_24h_times(token)
      token = self.scan_for_numbers(token)
      token = self.scan_for_month_names(token)
      token = self.scan_for_day_names(token)
      token = self.scan_for_special_text(token)
      token = self.scan_for_units(token)
    end

    tokens = self.split_time_tokens(tokens)
    tokens
  end

  def self.scan_for_numbers(token)
    num = Float(token.word) rescue nil
    token.update(:number, nil, num.to_i) if num
    token
  end

  def self.scan_for_24h_times(token)
    if token.word =~ /(2[0-3]|[01]?[0-9]):([0-5]?[0-9])/
      token.update(:time, nil, nil)
    end
    token
  end

  def self.scan_for_month_names(token)
    scanner = {/^jan\.?(uary)?$/ => :january,
      /^feb\.?(ruary)?$/ => :february,
      /^mar\.?(ch)?$/ => :march,
      /^apr\.?(il)?$/ => :april,
      /^may$/ => :may,
      /^jun\.?e?$/ => :june,
      /^jul\.?y?$/ => :july,
      /^aug\.?(ust)?$/ => :august,
      /^sep\.?(t\.?|tember)?$/ => :september,
      /^oct\.?(ober)?$/ => :october,
      /^nov\.?(ember)?$/ => :november,
    /^dec\.?(ember)?$/ => :december}
    scanner.keys.each do |scanner_item|
      token.update(:month_name, scanner[scanner_item], 30) if scanner_item =~ token.word
    end
    token
  end

  def self.scan_for_day_names(token)
    scanner = {
      /^su[nm](day)?$/ => :sunday,
      /^m[ou]n(day)?$/ => :monday,
      /^t(ue|eu|oo|u|)s(day)?$/ => :tuesday,
      /^tue$/ => :tuesday,
      /^we(dnes|nds|nns)day$/ => :wednesday,
      /^wed$/ => :wednesday,
      /^th(urs|ers)day$/ => :thursday,
      /^thu$/ => :thursday,
      /^fr[iy](day)?$/ => :friday,
      /^sat(t?[ue]rday)?$/ => :saturday
    }

    day_sequence = {
      :sunday => 0,
      :monday => 1,
      :tuesday => 2,
      :wednesday => 3,
      :thursday => 4,
      :friday => 5,
      :saturday => 6
    }

    scanner.each do |scanner_item, day|
      position_in_sequence = day_sequence[day]
      token.update(:weekday, scanner[scanner_item], 7, position_in_sequence) if scanner_item =~ token.word
    end
    token
  end

  def self.scan_for_special_text(token)
    scanner = {/^other$/ => :other,
      /^begin(ing|ning)?$/ => :beginning,
      /^start$/ => :beginning,
      /^end$/ => :end,
      /^mid(d)?le$/ => :middle}
    scanner.keys.each do |scanner_item|
      token.update(:special, scanner[scanner_item], 7) if scanner_item =~ token.word
    end
    token
  end

  def self.scan_for_units(token)
    scanner = {
      /^year(ly)?s?|annually$/ => {:type => :year, :interval => 365, :start => :today},
      /^month(ly)?s?$/ => {:type => :month, :interval => 30, :start => :today},
      /^fortnights?$/ => {:type => :fortnight, :interval => 365, :start => :today},
      /^week(ly)?s?$/ => {:type => :week, :interval => 7, :start => :today},
      /^weekends?$/ => {:type => :weekend, :interval => 7, :start => :saturday},
      /^days?$/ => {:type => :day, :interval => 1, :start => :today},
      /^daily?$/ => {:type => :day, :interval => 1, :start => :today},
      /^minutes?$/ => {:type => :minute, :start => :today},
      /^hour(ly)?s?$/ => {:type => :hour, :start => :today},
      /^am|pm$/ => {:type => :meridiem}
    }
    scanner.keys.each do |scanner_item|
      if scanner_item =~ token.word
        token.update(scanner[scanner_item][:type], scanner[scanner_item][:start], scanner[scanner_item][:interval]) if scanner_item =~ token.word
      end
    end
    token
  end

  # Split time tokens into constituent hour and minute tokens
  def self.split_time_tokens(tokens)
    tokens_output = []
    tokens.each do |token|
      if (token.type == :time)
        time_parts = token.word.split(':')
        hour_token = Midnight::Token.new(time_parts[0].to_i)
        minute_token = Midnight::Token.new(time_parts[1].to_i)
        hour_token.update(:hour)
        minute_token.update(:minute)
        tokens_output << hour_token
        tokens_output << minute_token
      else
        tokens_output << token
      end
    end

    tokens_output
  end

end
