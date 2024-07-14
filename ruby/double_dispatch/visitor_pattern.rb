# =====================================================
# Without Double Dispatch Implementation
# =====================================================
class Shape
  def render
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end

  def export
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end
end

class Circle < Shape
  def radius
    5
  end

  def render
    "Rendering Circle with radius #{radius}"
  end

  def export
    "Exporting Circle with radius #{radius}"
  end
end

class Rectangle < Shape
  def width
    10
  end

  def height
    20
  end

  def render
    "Rendering Rectangle with width #{width} and height #{height}"
  end

  def export
    "Exporting Rectangle with width #{width} and height #{height}"
  end
end

circle = Circle.new
rectangle = Rectangle.new

puts circle.render    # => Rendering Circle with radius 5
puts rectangle.render # => Rendering Rectangle with width 10 and height 20
puts circle.export    # => Exporting Circle with radius 5
puts rectangle.export # => Exporting Rectangle with width 10 and height 20

# With this approach, whenever there is a new operation, we need to modify each element class to add the new operation.

# Pros:
# Simplicity: Fewer classes and interfaces to manage.

# Cons:
# Scalability: Adding new operations requires modifying each element class, violating the Open/Closed Principle.
# Tight Coupling: Each element class is tightly coupled with all operations, making the code less modular.


# =====================================================
# Double Dispatch Implementation
# =====================================================
class Shape2
  def accept(visitor)
    visitor.visit_shape(self)
  end
end

class Circle2 < Shape2
  def accept(visitor)
    visitor.visit_circle(self)
  end

  def radius
    5
  end
end

class Rectangle2 < Shape2
  def accept(visitor)
    visitor.visit_rectangle(self)
  end

  def width
    10
  end

  def height
    20
  end
end

class ShapeVisitor
  def visit_shape(shape)
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end

  def visit_circle(circle)
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end

  def visit_rectangle(rectangle)
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end
end

class RenderVisitor < ShapeVisitor
  def visit_circle(circle)
    "Rendering Circle with radius #{circle.radius}"
  end

  def visit_rectangle(rectangle)
    "Rendering Rectangle with width #{rectangle.width} and height #{rectangle.height}"
  end
end

class ExportVisitor < ShapeVisitor
  def visit_circle(circle)
    "Exporting Circle with radius #{circle.radius}"
  end

  def visit_rectangle(rectangle)
    "Exporting Rectangle with width #{rectangle.width} and height #{rectangle.height}"
  end
end


circle2 = Circle2.new
rectangle2 = Rectangle2.new

render_visitor = RenderVisitor.new
export_visitor = ExportVisitor.new

puts circle2.accept(render_visitor)    # => Rendering Circle with radius 5
puts rectangle2.accept(render_visitor) # => Rendering Rectangle with width 10 and height 20
puts circle2.accept(export_visitor)    # => Exporting Circle with radius 5
puts rectangle2.accept(export_visitor) # => Exporting Rectangle with width 10 and height 20

# If we want to add a new operation, we only need to create a new visitor class and implement the operation for each element class.
# The existing element classes are untouched.

# Pros:
# Scalability: Adding new operations requires creating a new visitor class, adhering to the Open/Closed Principle.
# Modularity: Each visitor class is responsible for a single operation, making the code more modular and easier to maintain.

# Cons:
# Complexity: Introducing multiple visitor classes can make the codebase more complex and harder to understand.
# Boilerplate: Implementing the visitor pattern requires creating additional classes and methods, which can lead to more boilerplate code.