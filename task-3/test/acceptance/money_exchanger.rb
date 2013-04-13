require_relative 'test_helper'

"""
Currency exchanger service allows user to exchange currencies.

A user can supply money to bank accounts (each account accepts only one type of
currency) and exchange the many according to exchange rates.
"""

describe "currency exchanger" do
  include CurrencyExchangeHelper

  context "user with two bank accounts EUR and PLN" do
    specify "exchange of all money from the EUR account" do
      set_balance :eur => "100", :pln => "0"
      set_exchange_rate [:eur,:pln] => "4.15"
      exchange_money :eur, :pln
      get_balance(:eur).should == "0"
      get_balance(:pln).should == "415"
    end

    specify "exchange of money with specified amount of EUR" do
      set_balance :eur => "100", :pln => "0"
      set_exchange_rate [:eur,:pln] => "4.15"
      exchange_money :eur, :pln, :eur => "50"
      get_balance(:eur).should == "50"
      get_balance(:pln).should == "205.75"
    end

    specify "exchange of money with specified amount of PLN" do
      set_balance :eur => "100", :pln => "0"
      set_exchange_rate [:eur,:pln] => "4.15"
      exchange_money :eur, :pln, :pln => "200.03"
      get_balance(:eur).should == "51.80"
      #The resulting amount of target currency should be no-less than the specified
      #value, if the exact value cannot be obtained.
      get_balance(:pln).should == "200.03"
    end
  end
end
