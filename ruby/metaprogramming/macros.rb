# `Macros` typically refer to methods that generate other methods or code constructs at runtime
# `Macros` are not a built-in feature of Ruby,
# but they are a common pattern used in Ruby libraries and frameworks

# Example:
# The simulates how Rails implements the `attr_accessor` macro
# But this is not the actual implementation of `attr_accessor` in Rails
module CustomActiveModel
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attribute_accessor(*attrs)
      attrs.each do |attr|
        define_method(attr) do
          instance_variable_get("@#{attr}")
        end

        define_method("#{attr}=") do |value|
          instance_variable_set("@#{attr}", value)
        end
      end
    end
  end
end

class Person
  include CustomActiveModel

  attribute_accessor :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end
end

person = Person.new
person.first_name = 'John'
person.last_name = 'Doe'
p person.full_name
# => "John Doe"
