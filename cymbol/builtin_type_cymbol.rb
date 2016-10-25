class BuiltinTypeCymbol < Cymbol
  attr_accessor :name

  def initialize(name)
    super(BuiltinTypeCymbol, self)
    self.name = name
  end

  def to_s
    name
  end
end
