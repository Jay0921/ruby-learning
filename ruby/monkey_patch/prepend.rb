require_relative 'original'

# Approach 2: Prepend

# The prepend method inserts the module before the class in the ancestor chain.
# Since Ruby searches the ancestor chain from the beginning, the module will be searched first.
# This allows the module to override the methods in the class.
# The original methods in the class will remain

module Extension
  def greet
    'Hello, I am monkey patched.'
  end
end

Original.prepend(Extension)

original = Original.new
p original.greet
# Hello, I am monkey patched.
p original.this_remain_the_same
# This remain the same.

p Original.ancestors.inspect
# [Extension, Original, Object, Kernel, BasicObject]
p Original.singleton_class.ancestors.inspect
# [#<Class:Original>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
