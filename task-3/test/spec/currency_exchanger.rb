require_relative '../../lib/exchanger/currency_exchanger'
require_relative 'spec_helper'

describe CurrencyExchanger do
  subject(:exchanger)   { CurrencyExchanger.new(source_account,target_account,rate) }
  let(:source_account)  { mock }
  let(:target_account)  { mock }
  let(:rate)            { "4.15" }
  let(:source_initial_amount)   { "100" }
  let(:target_initial_amount)   { "0" }

  context "without a limit specified" do
    let(:source_final_amount)   { "0" }
    let(:target_final_amount)   { "415" }

    it "should exchange all money" do
      mock(source_account).withdraw(source_initial_amount)
      mock(target_account).deposit(target_final_amount)

      exchanger.exchange()
    end
  end

  context "with a limit specified for the source currency" do
    let(:source_final_amount)   { "50" }
    let(:target_final_amount)   { "205.75" }
    let(:limit)                 { "50" }

    it "should exchange the specified amount of money" do
      mock(source_account).withdraw(source_initial_amount)
      mock(target_account).deposit(target_final_amount)

      exchanger.exchange(:source => limit)
    end
  end

  context "with a limit specified for the target currency" do
    let(:source_final_amount)   { "51.80" }
    let(:target_final_amount)   { "200.03" }
    let(:limit)                 { "200" }

    it "should exchange the specified amount of money" do
      mock(source_account).withdraw(source_initial_amount)
      mock(target_account).deposit(target_final_amount)

      exchanger.exchange(:target => limit)
    end
  end

end
