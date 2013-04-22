require 'spec_helper'
require 'dhl-shipping/dhl-shipping'

describe DhlShipping do
  describe ".new" do
    it "must return an instance of DhlShipping" do
      DhlShipping.new.must be_an_instance_of(DhlShipping)
    end
  end
end