module CreditHelper

  def count_price(s,creditfirst,creditdate)
    s / 100
  end

  # def count_price(s,creditfirst,creditdate)
  #   first = s * creditfirst / 100
  #   c = s - first
  #   # percent = 0.00375
  #   # percent = 0.00825
  #   # percent = 0.005416667
  #   #percent = 0.002916667
  #   percent = 0.001583333
  #
  #   date = creditdate * -1
  #   monthupper  = c * percent
  #   monthlower =  1 - ((1 + percent) ** date)
  #
  #   month = monthupper / monthlower
  #   # puts month
  #   month = month.round
  #   # month = month.to_s.gsub!(/\B(?=(\d{3})+(?!\d))/g, " ")
  # end
end