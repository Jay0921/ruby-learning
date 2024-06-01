# References:
# https://medium.com/@camfeg/dynamic-method-definition-with-rubys-define-method-b3ffbbee8197

# `define_method` define methods dynamically based on various conditions or inputs.

class Person
  [:name, :age, :gender].each do |attribute|
    define_method(attribute) do
      instance_variable_get("@#{attribute}")
    end

    define_method("#{attribute}=") do |value|
      instance_variable_set("@#{attribute}", value)
    end
  end

  define_method(:add) do |a, b|
    a + b
  end
end

person = Person.new
person.name = "Alice"
person.age = 30
person.gender = "Female"

p person.name
# Alice
p person.age
# 30
p person.gender
# Female
p person.add(1, 2)
# 3
