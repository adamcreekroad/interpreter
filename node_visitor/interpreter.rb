class Interpreter < NodeVisitor
  GLOBAL_SCOPE = {}

  def initialize(parser)
    @parser = parser
  end

  def visit_program(node)
    visit(node.block)
  end

  def visit_block(node)
    node.declarations.each { |declaration| visit(declaration) }
    visit(node.compound_statement)
  end

  def visit_var_decl(node)
  end

  def visit_type(node)
  end

  def visit_bin_op(node)
    case node.op.type
    when PLUS                   then visit(node.left) + visit(node.right)
    when MINUS                  then visit(node.left) - visit(node.right)
    when MUL                    then visit(node.left) * visit(node.right)
    when INTEGER_DIV, FLOAT_DIV then visit(node.left) / visit(node.right)
    end
  end

  def visit_unary_op(node)
    case node.op.type
    when PLUS  then +visit(node.expr)
    when MINUS then -visit(node.expr)
    end
  end

  def visit_num(node)
    node.value
  end

  def visit_compound(node)
    node.children.each { |child| visit(child) }
  end

  def get_variable(name)
    if (existing = GLOBAL_SCOPE.keys.detect { |k| k if k.to_s.casecmp(name).zero? })
      existing
    else
      name
    end
  end

  def visit_assign(node)
    var_name = get_variable(node.left.value)
    GLOBAL_SCOPE[var_name] = visit(node.right)
  end

  def visit_var(node)
    var_name = get_variable(node.value)
    val = GLOBAL_SCOPE[var_name]
    raise(NameError, "Invalid variable name: #{var_name}") unless val
    val
  end

  def visit_no_op(node)
  end

  def interpret
    tree = @parser.parse
    tree ? visit(tree) : ''
  end
end

class InterpreterError < StandardError
end

class NameError < StandardError
end
