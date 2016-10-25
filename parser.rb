class Parser
  def initialize(lexer)
    @lexer = lexer
    @current_token = @lexer.next_token
  end

  def error
    raise ParseError, "Invalid Syntax: #{@current_token}"
  end

  def eat(token_type)
    if @current_token.type == token_type
      @current_token = @lexer.next_token
    else
      raise ParseError, "Invalid Syntax: current type: #{@current_token.type}, next type: #{token_type}, current_token: #{@current_token}"
    end
  end

  def program
    eat(PROGRAM)
    var_node = variable
    prog_name = var_node.value
    eat(SEMI)
    block_node = block
    program_node = Program.new(prog_name, block_node)
    eat(DOT)
    program_node
  end

  def block
    Block.new(declarations, compound_statement)
  end

  def declarations
    declarations = []
    if @current_token.type == VAR
      eat(VAR)
      while @current_token.type == ID
        declarations += variable_declaration
        eat(SEMI)
      end
    end
    declarations
  end

  def variable_declaration
    var_nodes = [Var.new(@current_token)]
    eat(ID)
    while @current_token.type == COMMA
      eat(COMMA)
      var_nodes << Var.new(@current_token)
      eat(ID)
    end
    eat(COLON)
    type_node = type_spec
    var_nodes.map { |var_node| VarDecl.new(var_node, type_node) }
  end

  def type_spec
    token = @current_token
    eat(@current_token.type)
    Type.new(token)
  end

  def compound_statement
    eat(P_BEGIN)
    nodes = statement_list
    eat(P_END)

    root = Compound.new
    nodes.each { |node| root.children << node }
    root
  end

  def statement_list
    node = statement
    results = [node]

    while @current_token.type == SEMI
      eat(SEMI)
      results << statement
    end

    error if @current_token.type == ID

    results
  end

  def statement
    case @current_token.type
    when P_BEGIN then compound_statement
    when ID      then assignment_statement
    else empty
    end
  end

  def assignment_statement
    left = variable
    token = @current_token
    eat(ASSIGN)
    right = expr
    Assign.new(left, token, right)
  end

  def variable
    node = Var.new(@current_token)
    eat(ID)
    node
  end

  def empty
    NoOp.new
  end

  def factor
    token = @current_token
    if [PLUS, MINUS].include?(token.type)
      eat(token.type)
      UnaryOp.new(token, factor)
    elsif [INTEGER_CONST, REAL_CONST].include?(token.type)
      eat(token.type)
      Num.new(token)
    elsif token.type == PAREN
      eat(PAREN)
      node = expr
      eat(PAREN)
      node
    else
      variable
    end
  end

  def term
    node = factor
    while [MUL, INTEGER_DIV, FLOAT_DIV].include?(@current_token.type)
      token = @current_token
      eat(token.type)
      node = BinOp.new(node, token, factor)
    end
    node
  end

  def expr
    node = term
    while [PLUS, MINUS].include?(@current_token.type)
      token = @current_token
      eat(token.type)
      node = BinOp.new(node, token, term)
    end
    node
  end

  def parse
    node = program
    error if @current_token.type != EOF
    node
  end
end

class ParseError < StandardError
end
