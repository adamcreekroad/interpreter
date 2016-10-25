class UnaryOp < AST
  attr_accessor :token, :op, :expr

  def initialize(op, expr)
    self.token = op
    self.op = op
    self.expr = expr
  end
end
