# Blocks are chunks of code that you can pass to methods as arguments.
# They are not objects, but they can be converted to objects (Procs) if needed.
# Blocks are usually enclosed in {} or do...end.

# Characteristics of Blocks:

# 1) Not Objects: Blocks are not objects themselves, but they can be converted to Proc objects.
# 2) Single Block per Method: A method can only receive one block.
# 3) Yield: You can execute a block from within a method using the yield keyword.
# 4) Optional: Blocks are optional, and methods can be defined to work with or without them.

def greeting
  @first_name = "John"
  yield if block_given?
  # The @last_name variable is defined in the block,
  # but it is accessible in the greet method after the block is yielded.
  p @last_name
end

greeting do
  # The @first_name variable is defined in the greet method,
  # but it is accessible in the block.
  p @first_name
  @last_name = "Doe"
  p "Hello, World!"
end

# =>
# "John"
# "Hello, World!"
# "Doe"


p "====================================================="

# How Block works with return statement:
def test_block
  [1, 2, 3].each do |num|
    return "Block return value" if num == 2
  end
  "End of method"
end

puts test_block
# => Block return value

# The `return` inside the block causes the test_block method to return immediately when num equals 2.
