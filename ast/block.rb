class Block < AST
  attr_accessor :declarations, :compound_statement

  def initialize(declarations, compound_statement)
    self.declarations = declarations
    self.compound_statement = compound_statement
  end
end
