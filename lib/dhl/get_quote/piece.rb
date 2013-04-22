class Dhl::GetQuote::Piece
  REQUIRED = [ :height, :weight, :width, :depth ]
  def initialize(options = {})
    REQUIRED.each do |req|
      if options[req].to_i > 0
        instance_variable_set("@#{req}", options[req].to_i)
      else
        raise Dhl::GetQuote::OptionsError, ":#{req} is a required for Dhl::GetQuote::Piece. Must be nonzero integer."
      end
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
  <Height>#{@height}</Height>
  <Weight>#{@weight}</Weight>
  <Width>#{@width}</Width>
  <Depth>#{@depth}</Depth>
</Piece>
eos
  end
end