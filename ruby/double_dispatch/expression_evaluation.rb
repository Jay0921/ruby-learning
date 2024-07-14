DEBUG = false

class Expression
  def evaluate
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end

  def pretty_print
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end
end

class Literal < Expression
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def evaluate
    value
  end

  def pretty_print
    value.to_s
  end
end

class Addition < Expression
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate
    left.evaluate + right.evaluate
  end

  def pretty_print
    "(#{left.pretty_print} + #{right.pretty_print})"
  end
end

class Subtraction < Expression
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def evaluate
    left.evaluate - right.evaluate
  end

  def pretty_print
    "(#{left.pretty_print} - #{right.pretty_print})"
  end
end

# Constructing the expression: (3 + 5)
literal1 = Literal.new(3)
literal2 = Literal.new(5)
addition = Addition.new(literal1, literal2)
subtraction = Subtraction.new(literal1, literal2)

# Evaluating the expression
result = addition.evaluate
puts addition.pretty_print # => (3 + 5)
puts result # => 8
result = subtraction.evaluate
puts subtraction.pretty_print # => (3 - 5)
puts result # => -2

# Without using double dispatch, we would have to add a new method to each subclass of Expression

class Expression
  def accept(visitor)
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end
end

class Literal < Expression
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def accept(visitor)
    puts "Literal#accept" if DEBUG
    visitor.visit_literal(self)
  end
end

class Addition < Expression
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def accept(visitor)
    puts "Addition#accept" if DEBUG
    visitor.visit_addition(self)
  end
end

class Subtraction < Expression
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def accept(visitor)
    visitor.visit_subtraction(self)
  end
end

class ExpressionVisitor
  def visit_literal(literal)
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end

  def visit_addition(addition)
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end
end

class EvaluateVisitor < ExpressionVisitor
  def visit_literal(literal)
    puts "EvaluateVisitor#visit_literal" if DEBUG
    literal.value
  end

  def visit_addition(addition)
    puts "EvaluateVisitor#visit_addition" if DEBUG
    visit(addition.left) + visit(addition.right)
  end

  def visit_subtraction(subtraction)
    puts "EvaluateVisitor#visit_subtraction" if DEBUG
    visit(subtraction.left) - visit(subtraction.right)
  end

  def visit(expression)
    puts "EvaluateVisitor#visit class: #{expression.class}" if DEBUG
    expression.accept(self)
  end
end

class PrettyPrintVisitor < ExpressionVisitor
  def visit_literal(literal)
    puts "PrettyPrintVisitor#visit_literal" if DEBUG
    literal.value.to_s
  end

  def visit_addition(addition)
    puts "PrettyPrintVisitor#visit_addition" if DEBUG
    "(#{visit(addition.left)} + #{visit(addition.right)})"
  end

  def visit_subtraction(subtraction)
    puts "PrettyPrintVisitor#visit_subtraction" if DEBUG
    "(#{visit(subtraction.left)} - #{visit(subtraction.right)})"
  end

  def visit(expression)
    puts "PrettyPrintVisitor#visit class: #{expression.class}" if DEBUG
    expression.accept(self)
  end
end

literal1 = Literal.new(3)
literal2 = Literal.new(5)
addition = Addition.new(literal1, literal2)
subtraction = Subtraction.new(literal1, literal2)

evaluator = EvaluateVisitor.new
pretty_printer = PrettyPrintVisitor.new

puts pretty_printer.visit(addition) # => (3 + 5)
puts evaluator.visit(addition) # => 8
puts pretty_printer.visit(subtraction) # => (3 - 5)
puts evaluator.visit(subtraction) # => -2
