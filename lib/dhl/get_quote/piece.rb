class Dhl::GetQuote::Piece
  attr_accessor :piece_id
  REQUIRED = [ :height, :weight, :width, :depth ]
  def initialize(options = {})
    REQUIRED.each do |req|
      if options[req].to_i > 0
        instance_variable_set("@#{req}", options[req].to_i)
      else
        raise Dhl::GetQuote::OptionsError, ":#{req} is a required for Dhl::GetQuote::Piece. Must be nonzero integer."
      end
      @piece_id = options[:piece_id] || 1
    end
  end

  def to_h
    h = {}
    REQUIRED.each do |req|
      h[req.to_s.capitalize] = instance_variable_get("@#{req}")
    end
    h
  end

  def to_xml
<<eos
<Piece>
  <PieceID>#{@piece_id}</PieceID>
  <Height>#{@height}</Height>
  <Depth>#{@depth}</Depth>
  <Width>#{@width}</Width>
  <Weight>#{@weight}</Weight>
</Piece>
eos
  end
end