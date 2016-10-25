class NodeVisitor
  def method_name_for(node)
    node.class.name.split(/(?=[A-Z])/).map(&:downcase).join('_')
  end

  def visit(node)
    generic_visit(node) unless respond_to?("visit_#{method_name_for(node)}")
    send("visit_#{method_name_for(node)}", node)
  end

  def generic_visit(node)
    raise StandardError, "visit_#{method_name_for(node)} is not defined"
  end
end
