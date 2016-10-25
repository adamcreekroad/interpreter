class VarCymbol < Cymbol
  attr_accessor :name, :type

  def initialize(name, type)
    super(VarCymbol, self)
    self.name = name
    self.type = type
  end

  def to_s
    "<#{name}:#{type}>"
  end
end
