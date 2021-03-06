require 'spec_helper'

describe Payment do

  let(:order) { mock_model(Order, :update! => nil) }
  # let(:payment) { Payment.new }
  before(:each) do
    @payment = Payment.new(:order => order)
    @payment.source = mock_model(Creditcard, :save => true, :payment_gateway => nil, :process => nil)
    @payment.stub!(:valid?).and_return(true)
    @payment.stub!(:check_payments).and_return(nil)
  end

  context "#process!" do

    context "when state is checkout" do
      before(:each) do
        @payment.source.stub!(:process!).and_return(nil)
      end
      it "should process the source" do
        @payment.source.should_receive(:process!)
        @payment.process!
      end
      it "should make the state 'processing'" do
        @payment.process!
        @payment.should be_processing
      end
    end

    context "when already processing" do
      before(:each) { @payment.state = 'processing' }
      it "should return nil without trying to process the source" do
        @payment.source.should_not_receive(:process!)
        @payment.process!.should == nil
      end
    end

  end

  context "#credit_payment" do
    it "should return first payment on same order that has this payment as its source"
    it "should return nil if order has no payments with this payment as its source"
  end

  context "#save" do
    it "should call order#update!" do
      payment = Payment.create(:amount => 100, :order => order)
      order.should_receive(:update!)
      payment.save
    end
  end

end
