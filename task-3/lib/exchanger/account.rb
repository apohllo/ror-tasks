module Exchanger
  class Account
    attr_reader :currency, :balance

    def initialize(currency,balance)
      @currency = currency
      @balance = balance
    end

    def withdraw(money)
      @balance -= money
    end

    def deposit(money)
      @balance += money
    end
  end
end
