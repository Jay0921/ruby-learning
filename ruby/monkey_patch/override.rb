require_relative 'original'

# Approach 3: Override
# The override approach simply redefines the method in the original class.
# The original method is no longer accessible because the new method with the same name has overridden it.
# Other methods in the original class will remain the same.

class Original
  def greet
    'Hello, I am monkey patched.'
  end
end

original = Original.new
p original.greet
# Hello, I am monkey patched.
p original.this_remain_the_same
# This remain the same.

p Original.ancestors.inspect
# [Original, Object, Kernel, BasicObject]
p Original.singleton_class.ancestors.inspect
# [#<Class:Original>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

# When you redefine a method in the class, Ruby updates the method table for that class, replacing the old method with the new one.
# Unlike including a module, this approach does not involve modifying the method lookup chain or dealing with module inclusion.
# It's a direct replacement within the class itself.
# This approach is the simplest and most straightforward way to monkey patch a class.
# However, it's also the most dangerous because it can easily break the original class if not done carefully.
