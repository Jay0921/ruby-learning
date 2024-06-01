# Lambdas
# Lambdas are a special kind of Proc with stricter argument checking and different behavior for the return statement.
# They are created using lambda or the -> syntax.

# Characteristics of Lambdas:
# 1) Stricter Argument Checking: Lambdas enforce the number of arguments strictly, raising an error if the number of arguments is incorrect.
# 2) Different Return Behavior: return in a lambda returns from the lambda itself, not from the enclosing method.
# 3) Objects: Like Procs, lambdas are objects.

lambda_example = lambda do |name|
  # The @first_name variable is defined in the call_lambda method,
  # but it is accessible inside the lambda.
  p @first_name
  @last_name = "Doe"
  p "Hello, #{name}!"
end

def call_lambda(lambda)
  @first_name = "John"
  lambda.call("Bob")
  # The @last_name variable is defined in the lambda,
  # but it is accessible in the call_lambda method after the lambda is called.
  p @last_name
end

call_lambda(lambda_example)
# lambda_example.call("Bob")
# =>
# "John"
# "Hello, Bob!"
# "Doe"

p "====================================================="

# Argument Handling:
# Strictly enforce the number of arguments. If the wrong number of arguments is passed, a ArgumentError is raised.
my_lambda = ->(x) { puts x }

my_lambda.call(10)
# => 10
# my_lambda.call       # ArgumentError: wrong number of arguments (given 0, expected 1)
# my_lambda.call(1, 2) # ArgumentError: wrong number of arguments (given 2, expected 1)


p "====================================================="

# Capturing Variables:
def make_multiplier(factor)
  lambda { |n| n * factor }
end

# The make_multiplier method returns a lambda that multiplies a number by the factor passed to make_multiplier.
multiplier_of_3 = make_multiplier(3)
p multiplier_of_3.call(10)
# => 30
multiplier_of_5 = make_multiplier(5)
p multiplier_of_5.call(10)
# => 50

p "====================================================="

# Persistent State
def counter
  # The outer_count variable is local to the counter method.
  outer_count = 0
  # The @method_count variable is shared between all Procs created by the counter method.
  @method_count = 0
  lambda do
    outer_count += 1
    @method_count += 1
    p "outer_count: #{outer_count}, method_count: #{@method_count}"
  end
end

counter1 = counter
counter2 = counter

counter1.call
# => "outer_count: 1, method_count: 1"
counter1.call
# => "outer_count: 2, method_count: 2"
counter2.call
# => "outer_count: 1, method_count: 3"
counter1.call
# => "outer_count: 3, method_count: 4"

p "====================================================="

# How Lambdas work with return statement:
def test_lambda
  [1, 2, 3].each do |num|
    my_lambda = lambda { return "Lambda return value" if num == 2 }
    p my_lambda.call
  end
  "End of method"
end

p test_lambda
# =>
# nil
# Lambda return value
# nil
# "End of method"

# The return inside the lambda only returns from the lambda itself, not the enclosing method.
# The method continues executing and returns the string "Method result: Lambda return value".
