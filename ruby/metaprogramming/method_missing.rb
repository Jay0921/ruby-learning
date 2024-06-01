# https://noelrappin.com/blog/2023/10/better-know-a-ruby-thing-10-method_missing/
# https://medium.com/podiihq/method-missing-in-ruby-af4c6edd5130

# `method_missing` allows you to intercept calls to methods that don't exist.
# When a method is called on an object and Ruby can't find a method with that name,
# it invokes the method_missing method of that object.
# You can override method_missing to handle these situations dynamically.

# Example: Dynamic Attribute Accessors
# This class allows you to dynamically set and get attributes.
# If you try to get an attribute that doesn't exist, it will return nil.
class DynamicAttributes
  def initialize
    @attributes = {}
  end

  def method_missing(name, *args, &block)
    attribute = name.to_s
    if attribute.end_with?('=')
      # Setter method
      @attributes[attribute.chop.to_sym] = args.first
    else
      # Getter method
      @attributes[attribute.to_sym]
    end
  end

  def respond_to_missing?(name, include_private = false)
    true
  end
end

obj = DynamicAttributes.new
obj.name = "Alice"
p obj.name
# Alice
p obj.age
# nil

# Example: Method Delegation
# `method_missing` can also be used to create proxy objects that delegate method calls to another object.
# This is useful for creating wrappers or decorators.
class Proxy
  def initialize(target)
    @target = target
  end

  def method_missing(name, *args, &block)
    @target.send(name, *args, &block)
  end

  def respond_to_missing?(name, include_private = false)
    @target.respond_to?(name, include_private) || super
  end
end

class Target
  def greet
    "Hello from Target!"
  end
end

target = Target.new
proxy = Proxy.new(target)
p proxy.greet
# Hello from Target!
p proxy.respond_to?(:greet)
# true
