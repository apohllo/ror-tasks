require_relative '../../lib/exchanger/account'
require_relative '../../lib/exchanger/money'
require_relative '../../lib/exchanger/exceptions'
require_relative 'spec_helper'

module Exchanger
  describe Account do
    subject(:account)     { Account.new(currency,balance) }
    let(:currency)        { :eur }
    let(:balance)         { Money("100") }

    it "should return its currency" do
      account.currency.should == currency
    end

    it "should return its balance" do
      account.balance.should == balance
    end

    it "should accept money deposits" do
      account.deposit(Money("50"))
      account.balance.should == Money("150")
    end

    it "should accept money withdrawals" do
      account.withdraw(Money("50"))
      account.balance.should == Money("50")
    end
  end
end
