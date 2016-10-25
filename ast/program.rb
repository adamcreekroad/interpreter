class Program < AST
  attr_accessor :name, :block

  def initialize(name, block)
    self.name = name
    self.block = block
  end
end
