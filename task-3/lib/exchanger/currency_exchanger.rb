module Exchanger
  class CurrencyExchanger
    attr_writer :calculator

    # Initialize the exchanger with a +source_account+, a +target_account+ and
    # exchange +rate+. The money is withdrawn from the source account and
    # deposited to the target account according to the exchange rate.
    def initialize(source_account,target_account,rate)
      @source_account = source_account
      @target_account = target_account
      @rate = rate
    end

    # Exchange the money. The exchange limit might be as follows:
    # * nil - all money on the source account is exchanged
    # * :source => value - the limit +value+ is expressed in the currency of the
    #   source account
    # * :target => value - the limit +value+ is expressed in the currency of the
    #   target account
    #
    # If the amount of money imposed by the limit would exceed the money available
    # on the source account all money available on the source account is
    # exchanged.
    def exchange(limit=nil)
      source_amount = compute_source_amount(limit)
      source_amount = @source_account.balance if source_amount > @source_account.balance
      target_amount = calculator.compute_target_amount(source_amount,@rate)
      @source_account.withdraw(source_amount)
      @target_account.deposit(target_amount)
    end

    private
    def compute_source_amount(limit)
      return @source_account.balance if limit.nil?
      if limit[:target]
        calculator.compute_source_amount(limit[:target],@rate)
      else
        limit[:source]
      end
    end

    def calculator
      @calculator ||= Calculator.new
    end
  end
end
