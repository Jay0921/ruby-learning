# References:
# https://medium.com/@leo_hetsch/ruby-modules-include-vs-prepend-vs-extend-f09837a5b073
# `prepend` adds the methods of the module as instance methods in the class.

module Logging
  def log(message)
    puts "Logging: #{message}"
  end

  def debug(message)
    puts "Logging: #{message}"
  end

  def error(message)
    puts "Logging: #{message}"
  end
end

module Debug
  def debug(message)
    puts "Debug: #{message}"
  end
end

class Service
  prepend Logging
  prepend Debug

  def log(message)
    puts "Service: #{message}"
  end
end

# `prepend`: Inserts the module before the class in the ancestors chain.
# This means that the methods in the module will be called first, even if the class has a method with the same name.

puts Service.ancestors.inspect
# [Debug, Logging, Service, Object, Kernel, BasicObject]
puts Service.singleton_class.ancestors.inspect
# [#<Class:Service>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

# Method Lookup Path:
# When calling instance methods on an object, Ruby will look up the method in the following order:
# 1. The included modules in the class, in reverse order of inclusion. In this case, Ruby will first look in Debug, then Logging
# 2. The actual class of the object, in this case, Service
