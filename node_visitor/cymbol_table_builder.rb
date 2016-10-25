class CymbolTableBuilder < NodeVisitor
  attr_accessor :cymbol_table

  def initialize
    self.cymbol_table = CymbolTable.new
  end

  def visit_program(node)
    visit(node.block)
  end

  def visit_block(node)
    node.declarations.each { |declaration| visit(declaration) }
    visit(node.compound_statement)
  end

  def visit_bin_op(node)
    visit(node.left)
    visit(node.right)
  end

  def visit_num(node)
  end

  def visit_unary_op(node)
    visit(node.expr)
  end

  def visit_compound(node)
    node.children.each { |child| visit(child) }
  end

  def visit_no_op(node)
  end

  def visit_var_decl(node)
    type_name = node.type_node.value
    type_cymbol = cymbol_table.lookup(type_name)
    var_name = node.var_node.value
    var_cymbol = VarCymbol.new(var_name, type_cymbol)
    cymbol_table.define(var_cymbol)
  end

  def visit_assign(node)
    var_name = node.left.value
    var_cymbol = cymbol_table.lookup(var_name)
    raise(NameError, "Undefined variable #{var_name}") unless var_cymbol
    visit(node.right)
  end

  def visit_var(node)
    var_name = node.value
    var_cymbol = cymbol_table.lookup(var_name)
    raise(NameError, "Undefined variable #{var_name}") unless var_cymbol
  end
end
