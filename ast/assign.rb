class Assign < AST
  attr_accessor :left, :op, :right, :token

  def initialize(left, op, right)
    self.left = left
    self.op = op
    self.right = right
    self.token = op
  end
end
