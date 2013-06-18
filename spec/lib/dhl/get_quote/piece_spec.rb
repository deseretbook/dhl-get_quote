require 'spec_helper'
require 'dhl-get_quote'

describe Dhl::GetQuote::Piece do

  let(:valid_params) do
    { :height  => 1, :weight => 2, :width => 3, :depth => 4 }
  end

  let(:klass) { Dhl::GetQuote::Piece }

  subject do
    klass.new(valid_params)
  end

  describe ".new" do
    it "must return an instance of Dhl::Piece" do
      klass.new(valid_params).must be_an_instance_of(klass)
    end

    it "must throw an error if a weight is not passed" do
      lambda do
        klass.new(valid_params.merge(:weight => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end

    it "must allow only weight to be passed" do
      klass.new( { :weight => 1 } ).must be_an_instance_of(klass)
    end

    it "must throw an error if a height is passed but width or depth is not" do
      lambda do
        klass.new(valid_params.merge(:width => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
      lambda do
        klass.new(valid_params.merge(:depth => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end

    it "must throw an error if a width is passed but height or depth is not" do
      lambda do
        klass.new(valid_params.merge(:height => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
      lambda do
        klass.new(valid_params.merge(:depth => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end

    it "must throw an error if a depth is passed but height or width is not" do
      lambda do
        klass.new(valid_params.merge(:height => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
      lambda do
        klass.new(valid_params.merge(:width => nil))
      end.must raise_exception(Dhl::GetQuote::OptionsError)
    end
  end

  describe "#to_h" do
    it "must return a hash representing the object" do
      subject.to_h.must == {
        "Height" => 1,
        "Weight" => 2,
        "Width"  => 3,
        "Depth"  => 4
      }
    end
  end

  describe "#to_xml" do
    it "must return an xml string representing the object" do
      subject.to_xml.must == <<eos
<Piece>
  <PieceID>1</PieceID>
  <Height>1.0</Height>
  <Depth>4.0</Depth>
  <Width>3.0</Width>
  <Weight>2.0</Weight>
</Piece>
eos
    end

    it "must generate a xml with only weight and PieceID" do
      dhl = klass.new( { :weight => 99 } )
      dhl.to_xml.must == <<eos
<Piece>
  <PieceID>1</PieceID>
  <Weight>99.0</Weight>
</Piece>
eos
    end

    it "must allow PieceID to be overridd" do
      dhl = klass.new( { :weight => 1 } )
      dhl.piece_id = 88
      dhl.to_xml.must == <<eos
<Piece>
  <PieceID>88</PieceID>
  <Weight>1.0</Weight>
</Piece>
eos
    end
  end
end
