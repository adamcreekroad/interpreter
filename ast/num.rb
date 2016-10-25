class Num < AST
  attr_accessor :token, :value

  def initialize(token)
    self.token = token
    self.value = token.value
  end
end
