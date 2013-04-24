module Dhl::GetQuote::Helper
  def underscore(camel_cased_word)
    self.class.underscore(camel_cased_word)
  end

  module ClassMethods
    def underscore(camel_cased_word)
      camel_cased_word.gsub(/([A-Z]{1})([A-Z]{1})/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end