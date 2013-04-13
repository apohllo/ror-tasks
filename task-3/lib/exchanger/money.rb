require 'bigdecimal'

class Money < BigDecimal
end

# This allows us to call Money("10.10") instead of Money.new("10.10")
def Money(*args)
  Money.new(*args)
end
