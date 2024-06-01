# References:
# https://www.writesoftwarewell.com/class_eval_vs_instance_eval_in_ruby/

# |---------|--------------------------|--------------------------------------------|
# |  type   |       class_eval         |                instance_eval               |
# |---------|--------------------------|--------------------------------------------|
# | Class   | Defines Instance methods | Defines Class methods                      |
# | instance| None                     | Defines a method on this specific instance |
# |---------|--------------------------|--------------------------------------------|

class Person
  def initialize
    @instance_variable = "I'm an instance variable"
  end
end

# `class_eval/module_eval` is used to evaluate code in the context of a class or module.
# This means that any methods defined inside this block are added as instance methods of the class.
# `class_eval` operates within the scope of the class itself, so it affects the instance methods.
Person.class_eval do
  def self.class_method
    p "I'm a class method"
  end

  def instance_method
    p "I'm a instance method, #{@instance_variable}"
  end
end

# `instance_eval` is used to evaluate code in the context of a specific instance of an object.
# In Ruby, classes are objects too, so `instance_eval` can define methods on this class object.
# These methods become singleton methods of the class object, which are effectively class methods.
# `instance_eval` defines methods at the singleton level of the object it is called on.
Person.instance_eval do
  def class_method2
    p "I'm a class method2"
  end
end

Person.class_method
# I'm a class method

person = Person.new
person.instance_method
# I'm a instance method

Person.class_method2
# I'm a class method2

person.instance_eval do
  def new_instance_method
    p "I'm a new instance method, #{@instance_variable}"
  end
end

person.new_instance_method
