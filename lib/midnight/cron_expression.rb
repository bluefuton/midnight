class Midnight::CronExpression #:nodoc:
  attr_writer :minute, :hour, :day_of_month, :month, :day_of_week, :force_run_every_minute

  def to_s
    return '* * * * *' if (@force_run_every_minute === true)

    expression_parts = [
      get_attribute(:minute),
      get_attribute(:hour),
      get_attribute(:day_of_month),
      get_attribute(:month),
      get_attribute(:day_of_week)
    ]

    # Better to return nil than accidentally recommend that people run a job every minute
    # Set force_run_every_minute to true to return * * * * * 
    if (expression_parts.select { |x| x != '*'}.empty?)
      return nil
    end 

    expression_parts.join(' ')
  end

  protected
  def get_attribute(symbol)
    attribute = instance_variable_get('@' + symbol.to_s)
    attribute.nil? ? '*' : attribute.to_s
  end
end