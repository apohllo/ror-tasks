module Exchanger
  class Account
    attr_reader :currency, :balance

    # Initialize the account with +currency+ and +balance+.
    def initialize(currency,balance)
      @currency = currency
      @balance = balance
    end

    # Withdraw +amount+ of money from the account.
    def withdraw(amount)
      check_amount(amount)
      @balance -= amount
    end

    # Deposit +amount+ of money to the account.
    def deposit(amount)
      check_amount(amount)
      @balance += amount
    end

    private
    def check_amount(amount)
      raise InvalidArgument.new("Amount of money cannot be nil") if amount.nil?
    end
  end
end
