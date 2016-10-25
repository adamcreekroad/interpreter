class Compound < AST
  attr_accessor :children

  def initialize
    self.children = []
  end
end
