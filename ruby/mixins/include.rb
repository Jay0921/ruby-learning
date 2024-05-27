# References:
# https://medium.com/@leo_hetsch/ruby-modules-include-vs-prepend-vs-extend-f09837a5b073

# `include` adds the methods of the module as instance methods in the class

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
  include Logging
  include Debug

  def log(message)
    puts "Service: #{message}"
  end
end

# `include``: Adds the module to the ancestors chain of the class, making the module's methods available as instance methods.
puts Service.ancestors.inspect
# [Service, Debug, Logging, Object, PP::ObjectMixin, Kernel, BasicObject]
puts Service.singleton_class.ancestors.inspect
# [#<Class:Service>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

service = Service.new
service.log('Hello, world!')
# Service: Hello, world!
service.debug('Hello, world!')
# Debug: Hello, world!
service.error('Hello, world!')
# Logging: Hello, world!

# Method Lookup Path:
# When calling instance methods on an object, Ruby will look up the method in the following order:
# 1. The actual class of the object, in this case, Service
# 2. The included modules in the class, in reverse order of inclusion. In this case, Ruby will first look in Debug, then Logging

# To override a method, simply define the method in a class or module that is lower in the ancestors chain.
