class Midnight::CronExpression #:nodoc:
  attr_writer :minute, :hour, :day_of_month, :month, :day_of_week

  def to_s
    expression_parts = [
      get_attribute(:minute),
      get_attribute(:hour),
      get_attribute(:day_of_month),
      get_attribute(:month),
      get_attribute(:day_of_week)
    ]

    expression_parts.join(' ')
  end

  protected
  def get_attribute(symbol)
    attribute = instance_variable_get('@' + symbol.to_s)
    attribute.nil? ? '*' : attribute.to_s
  end
end