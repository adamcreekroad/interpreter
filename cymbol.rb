class Cymbol
  attr_accessor :name, :type

  def initialize(name, type = nil)
    self.name = name
    self.type = type
  end
end
