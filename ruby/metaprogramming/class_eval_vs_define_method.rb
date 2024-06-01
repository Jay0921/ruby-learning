# define_method
# `define_method`` is used to define instance methods dynamically.
# It is a more precise and secure way to create methods because it doesn't involve evaluating strings of code,
# which can be prone to errors and security issues.

# Pros of define_method:
# Safer: No need to evaluate strings, reducing the risk of syntax errors and injection vulnerabilities.
# Clear Scope: The method is defined with a clear scope and access to the local variables available when the method was defined.

# Cons of define_method:
# Limited Flexibility: Can be less flexible compared to class_eval when you need to include complex logic or string-based evaluations.

# Example:
class Person
  [:name, :age, :gender].each do |attribute|
    define_method(attribute) do
      instance_variable_get("@#{attribute}")
    end

    define_method("#{attribute}=") do |value|
      instance_variable_set("@#{attribute}", value)
    end
  end
end

person = Person.new
person.name = "Alice"
person.age = 30
person.gender = "Female"

puts person.name
# => Alice
puts person.age
# => 30
puts person.gender
# => Female


# class_eval
# `class_eval` (or `module_eval``) evaluates a string or block of code in the context of a class.
# This method is more flexible and powerful, allowing for more complex metaprogramming tasks,
# but it comes with the risk of introducing errors and security issues if not used carefully.

# Pros of class_eval:
# Highly Flexible: Can evaluate strings of code, allowing for very dynamic and flexible method definitions.
# Access to Private/Protected Methods: Can define methods with access to private or protected methods and variables of the class.

# Cons of class_eval:
# Security Risks: Evaluating strings of code can introduce security risks, such as code injection vulnerabilities.
# Potentially Less Readable: Code can become harder to read and maintain, especially when dealing with complex logic.

# Example:
class Person
  [:name, :age, :gender].each do |attribute|
    class_eval <<-RUBY
      def #{attribute}
        @#{attribute}
      end

      def #{attribute}=(value)
        @#{attribute} = value
      end
    RUBY
  end
end

person = Person.new
person.name = "Alice"
person.age = 30
person.gender = "Female"

puts person.name
# => Alice
puts person.age
# => 30
puts person.gender
# => Female

# Key Differences

# Method Definition:
# `define_method` is used to define instance methods directly with a block.
# `class_eval` (or module_eval) can evaluate strings of code or blocks, providing a more flexible way to define both instance and class methods.

# Safety and Readability:
# `define_method` is generally safer and more readable, as it avoids string evaluation.
# `class_eval` is more powerful but can introduce security risks and reduce readability.

# Use Cases:
# Use `define_method` when you need to define instance methods dynamically in a safe and clear manner.
# Use `class_eval` when you need the flexibility to define complex logic dynamically, especially when working with class-level definitions or needing access to the class's private methods and variables.


# When to Use Each

# Use define_method:
# 1) When defining simple instance methods dynamically.
# 2) When you want to avoid the risks associated with evaluating strings of code.
# 3) When you want your code to be more readable and maintainable.

# Use class_eval:
# 1) When you need to define methods dynamically with complex logic.
# 2) When you need to access private/protected methods or variables.
# 3) When defining both instance and class methods dynamically.
# 4) When you need the flexibility to evaluate strings of code, despite the associated risks.