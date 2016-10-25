class BinOp < AST
  attr_accessor :left, :token, :op, :right

  def initialize(left, op, right)
    self.left = left
    self.token = op
    self.op = op
    self.right = right
  end
end
