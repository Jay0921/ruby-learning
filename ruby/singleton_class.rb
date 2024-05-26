# References:
# https://medium.com/@jeremy_96642/module-extend-understanding-ruby-singleton-classes-9dea718c80f2
# https://medium.com/@leo_hetsch/demystifying-singleton-classes-in-ruby-caf3fa4c9d91
# https://dev.to/samuelfaure/explaining-ruby-s-singleton-class-eigenclass-to-confused-beginners-cep

# - A singleton class is a special hidden class that holds methods specific to a single object or class.
# - In Ruby, there are no true class methods; instead, we use singleton methods aka instance methods that live in the singleton class.
# - When defining a method on a class, we are actually defining a singleton method on that class’s singleton class.

# To make it easier to understand, I will refer to Class:Vehicle as the singleton class and Vehicle as the actual class, which is an instance of Class:Vehicle.

class Vehicle
  def self.register
    puts "Registering..."
  end

  def self.unregister
    puts "Unregistering..."
  end
end

# The singleton class of Vehicle can be accessed using Vehicle.singleton_class:
puts Vehicle.singleton_class.inspect
# #<Class:Vehicle>

# The singleton class is hidden and not visible in the ancestors chain of Vehicle:
puts Vehicle.ancestors.inspect
# [Vehicle, Object, Kernel, BasicObject]

# The ancestors chain of the singleton class includes the singleton class itself and its hierarchy:
puts Vehicle.singleton_class.ancestors.inspect
# [#<Class:Vehicle>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

# The Vehicle class that we use in code is actually an instance of `Class:Vehicle`
# There is only one instance of the `Class:Vehicle` in memory. This can be proven by comparing the object_id of Vehicle in different parts of the code:
puts Vehicle.object_id == Vehicle.object_id
# true

# The register and unregister methods are instance methods of `Class:Vehicle`:
puts Vehicle.singleton_class.instance_methods(false).inspect
# [:register, :unregister]

# What happens when we subclass Vehicle?

class Car < Vehicle
end

puts Car.singleton_class.inspect
# #<Class:Car>

puts Car.ancestors.inspect
# [Car, Vehicle, Object, Kernel, BasicObject]

# The Class:Car has a reference to Class:Vehicle. This allows Ruby to look up methods directly through the chain of singleton classes without having to go through the instance method lookup path of the Vehicle class itself.
puts Car.singleton_class.ancestors.inspect
# [#<Class:Car>, #<Class:Vehicle>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]

Car.register
# Registering...

# Method Lookup Path:

# 1) Ruby first checks if register is defined in Class:Car.
# 2) Since register is not found in Class:Car, Ruby checks the singleton class of Vehicle (Class:Vehicle).

# Ruby does not check the instance methods of the class itself (Vehicle, Object, etc.) for class methods because class methods are only defined in the singleton classes.

# Car.singleton_class   # => #<Class:Car>
# |
# |  (Car does not define `register`)
# V
# Vehicle.singleton_class   # => #<Class:Vehicle>
# |
# |  (Vehicle defines `register`)
# V


# Below is an example of defining a method on a specific instance of a class:

car1 = Car.new
car2 = Car.new

def car1.new_method
  puts "This is a object-specific method"
end
car1.new_method

puts car1.singleton_class.inspect
# #<Class:#<Car:0x000000010ae3c5f0>>
puts car2.singleton_class.inspect
# # <Class:#<Car:0x000000010da1b540>>

puts car1.singleton_class.ancestors.inspect
# [#<Class:#<Car:0x000000010ae3c5f0>>, Car, Vehicle, Object, Kernel, BasicObject]

puts car2.singleton_class.ancestors.inspect
# [#<Class:#<Car:0x000000010da1b540>>, Car, Vehicle, Object, Kernel, BasicObject]

puts car1.singleton_class.instance_methods(false).inspect
# [:new_method]

# Ruby creates a singleton class for the specific instance to hold the new_method method.

# Method Lookup Path:

# 1) Ruby first checks the singleton class of car for the new_method.
# 2) If the method is not found in the singleton class, Ruby checks the class of car, which is Car.

# In this example:
# - car1 has a singleton class because we defined a singleton method on it.
# - car2 does not have a singleton class until we define a singleton method or modify it in some other way.

# Ruby does not create a singleton class for every object by default. A singleton class is only created when it's actually needed, such as when a singleton method is defined on an instance.

# Since we can call `singleton_class` on car2, does that mean that car2 has a singleton class?
# Calling singleton_class on any object will provide you with the singleton class of that object. This does not necessarily mean that a full-fledged singleton class with additional methods has been created and is consuming significant memory. The singleton class exists conceptually for every object, but it is more of a lightweight placeholder until you define a singleton method on the object. Ruby optimizes this by not creating a substantial data structure until necessary.
