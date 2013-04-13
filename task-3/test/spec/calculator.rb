require_relative '../../lib/exchanger/calculator'
require_relative '../../lib/exchanger/money'
require_relative '../../lib/exchanger/exceptions'
require_relative 'spec_helper'

module Exchanger
  describe Calculator do
    subject(:calculator)  { Calculator.new }

    context "with rate provided" do
      let(:rate)            { Money("4.19") }

      context "with source amount provided" do
        let(:source_amount)   { Money("100") }
        let(:target_amount)   { Money("419") }

        it "should compute valid amount of target currency" do
          calculator.compute_target_amount(source_amount,rate).should == target_amount
        end
      end

      context "with target amount below directly computed" do
        let(:target_amount)   { Money("400") }
        # 95.47 * 4.19 == 400.02
        let(:source_amount)   { Money("95.47") }

        it "should return directly computed source amount" do
          calculator.compute_source_amount(target_amount,rate).should == source_amount
        end
      end

      context "with target amount above directly computed" do
        let(:target_amount)   { Money("401") }
        # 95.70 * 4.19 == 400.98
        let(:source_amount)   { Money("95.71") }

        it "should increase directly computed source amount" do
          calculator.compute_source_amount(target_amount,rate).should == source_amount
        end
      end

      context "without source amount provided" do
        let(:source_amount)   { nil }

        it "should raise an error if target amount has to be computed " do
          expect{ calculator.compute_target_amount(source_amount,rate) }.to raise_error(InvalidArgument)
        end
      end

      context "with target amount provided" do
        let(:target_amount)   { nil }

        it "should raise an error if source amount has to be computed " do
          expect{ calculator.compute_source_amount(target_amount,rate) }.to raise_error(InvalidArgument)
        end
      end
    end

    context "without rate" do
      let(:rate)  { nil }
      let(:target_amount)   { Money("400") }
      let(:source_amount)   { Money("95.47") }

      it "should raise an error if target amount has to be computed" do
        expect {calculator.compute_source_amount(target_amount,rate)}.to raise_error(InvalidArgument)
      end

      it "should raise an error if source amount has to be computed" do
        expect {calculator.compute_target_amount(target_amount,rate)}.to raise_error(InvalidArgument)
      end
    end
  end
end
