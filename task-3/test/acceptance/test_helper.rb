class Account
  def initialize(currency,value)
  end
end


module CurrencyExchangeHelper
  def set_balance(accounts)
    @accounts ||= []
    accounts.each do |currency,value|
      @accounts << Account.new(currency,value)
    end
  end
end
