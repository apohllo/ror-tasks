module Exchanger
  class ExchangeRate
    attr_reader :source_currency, :target_currency, :value

    def initialize(source_currency,target_currency,value)
      @source_currency = source_currency
      @target_currency = target_currency
      @value = Money(value)
    end
  end
end
