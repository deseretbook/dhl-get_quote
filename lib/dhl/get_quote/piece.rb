class Dhl::GetQuote::Piece
  attr_accessor :piece_id

  def initialize(options = {})
    [ :width, :height, :depth, :weight ].each do |i|
      options[i] = options[i].to_i if !!options[i]
    end

    if options[:weight] && options[:weight] > 0
      @weight = options[:weight]
    else
      raise Dhl::GetQuote::OptionsError, required_option_error_message(:weight)
    end

    if options[:width] || options[:height] || options[:depth]
      [ :width, :height, :depth ].each do |req|
        if options[req].to_i > 0
          instance_variable_set("@#{req}", options[req].to_i)
        else
          raise Dhl::GetQuote::OptionsError, required_option_error_message(req)
        end
      end
    end

    @piece_id = options[:piece_id] || 1

  end

  def to_h
    h = {}
    [ :width, :height, :depth, :weight ].each do |req|
      if x = instance_variable_get("@#{req}")
        h[req.to_s.capitalize] = x
      end
    end
    h
  end

  def to_xml
    xml_str = <<eos
<Piece>
  <PieceID>#{@piece_id}</PieceID>
eos

    xml_str << "  <Height>#{@height}</Height>\n" if @height
    xml_str << "  <Depth>#{@depth}</Depth>\n" if @depth
    xml_str << "  <Width>#{@width}</Width>\n" if @width
    xml_str << "  <Weight>#{@weight}</Weight>\n" if @weight

    xml_str += "</Piece>\n"
    xml_str
  end

private

  def required_option_error_message(field)
    ":#{field} is a required for Dhl::GetQuote::Piece. Must be nonzero integer."
  end
end