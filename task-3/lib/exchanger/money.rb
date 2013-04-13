require 'bigdecimal'

module Exchanger
  class Money < BigDecimal
  end
end

# This allows us to call Money("10.10") instead of Money.new("10.10")
def Money(*args)
  Exchanger::Money.new(*args)
end
