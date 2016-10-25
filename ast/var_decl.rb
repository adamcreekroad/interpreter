class VarDecl < AST
  attr_accessor :var_node, :type_node

  def initialize(var_node, type_node)
    self.var_node = var_node
    self.type_node = type_node
  end
end
