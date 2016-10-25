class Token
  attr_accessor :type, :value

  def initialize(type, value)
    self.type = type
    self.value = value
  end

  def to_s
    "{ type: #{type}, value: #{value} }"
  end
end
