module Exchanger
  class Account
    attr_reader :currency

    def initialize(currency,value)
      @currency = currency
      @value = value
    end
  end
end
