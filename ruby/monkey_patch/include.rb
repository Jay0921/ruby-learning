require_relative 'original'
require 'active_support/concern'

# Approach 1: ActiveSupport::Concern

# Use ActiveSupport::Concern to include a module that has a method with the same name as the original class.
# The method in the module will override the method in the original class.
# Other methods in the original class will remain the same.
# The method in the module will be called instead of the original method.

module Extension
  extend ActiveSupport::Concern

  included do
    def greet
      'Hello, I am monkey patched.'
    end
  end
end

Original.include(Extension)
original = Original.new
p original.greet
# Hello, I am monkey patched.
p original.this_remain_the_same
# This remain the same.

p Original.ancestors.inspect
# [Original, Extension, Object, Kernel, BasicObject]
p Original.singleton_class.ancestors.inspect
# [#<Class:Original>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

# Ruby processes the included block and adds the greet method from the Extension module to the Original class.
# The original greet method in the Original class is replaced by the greet method from the Extension module.
# The original method is no longer accessible because the new method with the same name has overridden it.
