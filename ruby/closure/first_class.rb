# Ruby supports first-class functions, functions can be stored in variables,
# passed as arguments, and returned from other functions.

# There is not a direct way to store a block in a variable, but you can store it as a Proc object.
# Use the & operator to convert a block to a Proc object.
def greet(&block)
  block.call
end

greet do
  puts "Hello, World!"
end

p "====================================================="

# Procs can be stored in variables and passed as arguments.
add = Proc.new do |a, b|
  a + b
end

def add_and_display(array, proc)
  array.each do |a, b|
    p proc.call(a, b)
  end
end

add_and_display([[1, 2], [3, 4], [5, 6]], add)
# => 3
# => 7
# => 11

p "====================================================="

# Lambdas can also be stored in variables and passed as arguments.
subtract = ->(a, b) { a - b }

def subtract_and_display(array, lambda)
  array.each do |a, b|
    p lambda.call(a, b)
  end
end

subtract_and_display([[6, 1], [5, 2], [4, 3]], subtract)
# => 5
# => 3
# => 1
