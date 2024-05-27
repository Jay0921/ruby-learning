# References:
# https://medium.com/@leo_hetsch/ruby-modules-include-vs-prepend-vs-extend-f09837a5b073
# `extend` adds the methods of a module as class methods

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

  def enabled?
    puts @@logging_enabled
  end
end

module Debug
  def debug(message)
    puts "Debug: #{message}"
  end
end

class Service
  extend Logging
  extend Debug

  def self.log(message)
    puts "Service: #{message}"
  end
end

# `extend`: Adds the module to the ancestors chain of the class's singleton class, making the module's methods available as class methods.
puts Service.ancestors.inspect
# [Service, Object, Kernel, BasicObject]
puts Service.singleton_class.ancestors.inspect
# [#<Class:Service>, Debug, Logging, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

Service.log('Hello, world!')
# Logging: Hello, world!

Service.debug('Hello, world!')
# Debug: Hello, world!

Service.error('Hello, world!')
# Logging: Hello, world!

# Method Lookup Path:
# When calling class methods on a class, Ruby will look up the method in the following order:
# 1. The actual class of the object, in this case, Service.
# 2. The extended modules in the class, in reverse.

# To override a class method, simply define the method in a class or module that is lower in the ancestors chain.
