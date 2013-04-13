module Exchanger
  class Calculator
    # Returns the target amount of many if source +amount+ of money is exchanged
    # according to the exchange +rate+.
    def compute_target_amount(amount,rate)
      check_amount_and_rate(amount,rate)
      amount * rate
    end

    # Returns the source amount of money that has to be exchanged in order to
    # receive +target_amount+ of money according to the exchange +rate+ provided.
    #
    # It is assured that the resulting amount of money won't be lower than the
    # provided +target_amount+ of money. E.g. if we have to pay for a ticket in
    # a foreign currency we are sure that we'll have enough foreign currency
    # only by specifying the exact expected amount of money (and nothing more).
    def compute_source_amount(target_amount,rate)
      check_amount_and_rate(target_amount,rate)
      source_amount = (target_amount / rate).round(2,BigDecimal::ROUND_HALF_EVEN)
      increse_if_lower_than_expected(source_amount,target_amount,rate)
    end

    private
    def check_amount_and_rate(amount,rate)
      raise InvalidArgument.new("Exchange rate can't be nil") if rate.nil?
      raise InvalidArgument.new("Amount of money can't be nil") if amount.nil?
    end

    def increse_if_lower_than_expected(source_amount,target_amount,rate)
      if target_amount > compute_target_amount(source_amount,rate)
        source_amount + BigDecimal.new("0.01")
      else
        source_amount
      end
    end
  end
end
