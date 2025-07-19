# References:
# https://medium.com/rubycademy/refine-and-using-methods-in-ruby-part-i-2aef6d7a4325

require_relative 'original'

module TemporaryPatch
  refine Original do
    def greet
      'Hello, I am TemporaryPatch.'
    end
  end
end

using TemporaryPatch

original = Original.new
p original.greet
# "Hello, I am TemporaryPatch."

p Original.ancestors.inspect
# [Original, Object, Kernel, BasicObject]
p Original.singleton_class.ancestors.inspect
# [#<Class:Original>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
