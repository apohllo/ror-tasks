$:.unshift(File.join(File.dirname(__FILE__),"lib"))
require 'exchanger'

module CurrencyExchangeHelper
  def set_balance(accounts)
    @accounts ||= []
    accounts.each do |currency,value|
      @accounts << Account.new(currency,value)
    end
  end

  def set_exchange_rate(rates)
    @rates ||= []
    rates.each do |(source,target),value|
      @rates << ExchangeRate.new(source,target,value)
    end
  end

  def exchange_money(source,target,amount=nil)
    exchanger = CurrencyExchanger.new(find_account(source),find_account(target),
                                      find_rate(source,target))
    if amount
      if amount[source]
        amount = { :source => amount[source] }
      elsif amount[target]
        amount = { :target => amount[target] }
      else
        raise "Neither source nor target currency specified as limit." +
          "[#{source},#{target}] should include one of #{amount.keys.join(",")}"
      end
    end
    exchanger.exchange(amount)
  end

  def get_balance(currency)
    find_account(currency)
  end

  def find_account(currency)
  end

  def find_rate(source,target)
  end
end