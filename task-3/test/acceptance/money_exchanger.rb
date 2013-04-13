"""
Currency exchanger service allows user to exchange currencies.

A user can supply money to bank accounts (each account accepts only one type of
currency) and exchange the many according to exchange rates.
"""

describe "currency exchanger" do
  context "user with two bank accounts EUR and PLN" do
    specify "exchange of all money from the EUR account" do
      set_balance :eur => 100, :pln => 0
      set_exchange_rate [:eur,:pln] => 4.15
      exchange_money :eur,:pln
      get_balance(:eur).should == 0
      get_balance(:pln).should == 415
    end
  end
end
