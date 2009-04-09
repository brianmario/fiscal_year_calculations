module FiscalYearCalculations
  # The first day of the current fiscal quarter of this Time object instance, based on the passed offset_month
  def beginning_of_fiscal_quarter(offset_month=1)
    t = beginning_of_fiscal_year(offset_month)
    return t if self.month == offset_month
    4.times do
      return t if self >= t && self <= (t+2.months).end_of_month
      t = t+3.months
    end
  end
  
  # The very last day of the current fiscal quarter of this Time object instance, based on the passed offset_month
  def end_of_fiscal_quarter(offset_month=1)
    (beginning_of_fiscal_quarter(offset_month) + 2.months).end_of_month
  end
  
  # The first day of the fiscal year of this Time object instance, based on the passed offset_month
  def beginning_of_fiscal_year(offset_month=1)
    # NOTE: we set the day to the 1st to avoid problems with end of month days that don't exist in all months.
    # For example, if it's March 31st, and we switch the month to February, the Time object will switch back to March
    # since February doesn't have a 31st day, and assumes it's March 1st/2nd (leapyear)
    if offset_month <= self.month
      self.change(
        :month => offset_month,
        :day => 1
      ).beginning_of_month
    else
      self.change(
        :month => offset_month,
        :day => 1,
        :year => self.year-1
      ).beginning_of_month
    end
  end
  
  # The very last day of the fiscal year of this Time object instance, based on the passed offset_month
  def end_of_fiscal_year(offset_month=1)
    (beginning_of_fiscal_year(offset_month)+11.months).end_of_month
  end
  
  # Returns an array of starting dates for each quarter based on this Time object instance, and the passed offset_month
  def to_fiscal_quarters(offset_month=1)
    first_quarter = beginning_of_fiscal_year(offset_month)
    second_quarter = first_quarter+3.months
    third_quarter = second_quarter+3.months
    fourth_quarter = third_quarter+3.months
    
    [first_quarter, second_quarter, third_quarter, fourth_quarter]
  end
end

Time.send(:include, FiscalYearCalculations)