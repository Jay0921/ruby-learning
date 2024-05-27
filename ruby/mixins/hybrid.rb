# Sometimes, we want both instance methods and class methods.
# We can use a hybrid approach to achieve this.

# Approach 1: Include a module in a class and extend the class with another module.

module Logging
  module ClassMethods
    def logging_enabled?
      true
    end
  end

  # This method is called automatically when the module is included in a class.
  def self.included(base)
    base.extend(ClassMethods)
  end

  def log(message)
    puts "Logging: #{message}"
  end
end

class Service
  include Logging
end

puts Service.ancestors.inspect
# [Service, Logging, Object, Kernel, BasicObject]

puts Service.singleton_class.ancestors.inspect
# [#<Class:Service>, Logging::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

service = Service.new

# instance method from the Logging module
service.log("Hello, world!")
# Logging: Hello, world!

# class method from the Logging module
puts Service.logging_enabled?
# true


# =======================================================================================================
# =======================================================================================================
# =======================================================================================================

# Approach 2: Extend a class with a module and include another module in the class.

module Logging2
  module InstanceMethods
    def log(message)
      puts "Logging: #{message}"
    end
  end

  # This method is called automatically when the module is extended in a class.
  def self.extended(base)
    base.include(InstanceMethods)
  end

  def logging_enabled?
    true
  end
end

class Service2
  extend Logging2
end

puts Service2.ancestors.inspect
# [Service2, Logging2::InstanceMethods, Object, Kernel, BasicObject]

puts Service2.singleton_class.ancestors.inspect
# [#<Class:Service2>, Logging2, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

service2 = Service2.new

# instance method from the Logging2 module
service2.log("Hello, world!")
# Logging: Hello, world!

# class method from the Logging2 module
puts Service2.logging_enabled?
# true
