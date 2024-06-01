# Procs
# Procs are objects that encapsulate blocks of code, allowing you to store them in variables,
# pass them to methods, and reuse them. They are created using Proc.new or proc.

# Characteristics of Procs:
# 1) Objects: Procs are full-fledged objects.
# 2) Flexible Arguments: Procs do not enforce the number of arguments strictly.
# 3) Multiple Procs: You can pass multiple Procs to a method.
# 4) Returning: return in a Proc returns from the enclosing method if the Proc is defined within that method.

proc_example = Proc.new do |name|
  # The @first_name variable is defined in the call_proc method,
  # but it is accessible inside the Proc.
  p @first_name
  @last_name = "Doe"
  puts "Hello, #{name}!"
end

def call_proc(proc)
  @first_name = "John"
  proc.call("Alice")
  # The @last_name variable is defined in the Proc,
  # but it is accessible in the call_proc method after the Proc is called.
  p @last_name
end

call_proc(proc_example)
# =>
# "John"
# Hello, Alice!
# "Doe"

p "====================================================="

# Argument Handling:
# More lenient with arguments. If too many arguments are passed, the extra arguments are ignored.
# If too few arguments are passed, the missing arguments are set to nil.
my_proc = Proc.new { |x| puts x }

my_proc.call(10)
# => 10
my_proc.call
# => nil
my_proc.call(1, 2)
# => 1

p "====================================================="

# Capturing Variables:
def make_multiplier(factor)
  Proc.new { |n| n * factor }
end
# The make_multiplier method returns a Proc that multiplies a number by the factor passed to make_multiplier.

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
  Proc.new do
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

# How Procs work with return statement:
my_proc = Proc.new do |num|
  return "Proc return value" if num == 2
end

def test_proc(proc)
  [1, 2, 3].each do |num|
    proc.call(num)
  end
  "End of method"
end

p test_proc(my_proc)
# The return inside the Proc causes the test_proc method to return immediately when the Proc is called.
# The return here only stops the execution and it does not return a value from the Proc itself.
