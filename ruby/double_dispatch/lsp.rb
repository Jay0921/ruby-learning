# https://www.youtube.com/watch?v=kEfXPTm1aCI&t=1356s
# This is a simple example to simulate how language server protocol (LSP) uses double dispatch to
# traverse an abstract syntax tree (AST) and generate folding ranges for a code editor.

class Post
  def title
    "Title"
  end

  def body
    "Body"
  end
end

class Node
  attr_reader :children, :location

  def initialize(children = [], location = { start_line: 0, end_line: 0 })
    @children = children
    @location = { start_line: 0, end_line: 0 }.merge(location)
  end
end

class ClassNode < Node
  def accept(visitor)
    visitor.visit_class(self)
  end
end

class ConstNode < Node
  def accept(visitor)
    visitor.visit_const(self)
  end
end

class BodyNode < Node
  def accept(visitor)
    visitor.visit_body(self)
  end
end

class DefNode < Node
  def accept(visitor)
    visitor.visit_def(self)
  end
end

class Visitor
  def visit_children(node)
    node.children.each do |child|
      visit(child)
    end
  end

  alias_method :visit_class, :visit_children
  alias_method :visit_const, :visit_children
  alias_method :visit_body, :visit_children
  alias_method :visit_def, :visit_children

  def visit(node)
    node.accept(self)
  end
end

class FoldingRange < Visitor
  def initialize(ast)
    @ast = ast
    @ranges = []
  end

  def run
    visit(@ast)
    @ranges
  end

  def visit_class(node)
    location = node.location

    @ranges << {
      startLine: location[:start_line],
      endLine: location[:end_line],
      kind: "class"
    }

    super
  end

  def visit_def(node)
    location = node.location

    @ranges << {
      startLine: location[:start_line],
      endLine: location[:end_line],
      kind: "def"
    }

    super
  end
end

# Post#title
title_method_body = BodyNode.new([], { start_line: 3, end_line: 3 })
title_method_definition = DefNode.new([title_method_body], { start_line: 2, end_line: 4 })

# Post#body
body_method_body = BodyNode.new([], { start_line: 7, end_line: 7 })
body_method_definition = DefNode.new([body_method_body], { start_line: 6, end_line: 8 })

class_body = BodyNode.new([title_method_definition, body_method_definition], { start_line: 2, end_line: 8 })
class_definition = ClassNode.new([class_body], { start_line: 1, end_line: 9 })

p FoldingRange.new(class_definition).run