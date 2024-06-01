# References:
# https://medium.com/@pojotorshemi/send-me-a-river-ruby-send-method-3b295173e5c8
# https://yehudabortz.medium.com/rubys-send-method-why-it-s-important-c3bc9a911322

# `send` method allows you to call a method by name, even if the method name is stored in a variable, and pass arguments to it.
# This is particularly useful when you need to call methods whose names are not known until runtime.

# Basic Example:
class CustomActiveModel
  def self.validates(*attrs)
    attributes, options = attrs.partition { |attr| attr.is_a?(Symbol) }

    attributes.each do |attr|
      define_method("validate_presence_of_#{attr}") do
        value = instance_variable_get("@#{attr}")
        if value.nil?
          @errors << "#{attr} cannot be blank"
        end
      end
    end

    define_method(:valid?) do
      @errors = []

      attributes.each do |attr|
        # The `send` method is used to call the method dynamically based on the attribute name.
        send("validate_presence_of_#{attr}")
      end

      @errors.empty?
    end

    define_method(:errors) do
      @errors
    end
  end
end

class Person < CustomActiveModel
  validates :name, :age, presence: true

  def initialize(name: nil, age: nil)
    @name = name
    @age = age
    @errors = []
  end
end

person = Person.new(name: "Alice", age: 30)
p person.valid?
# => true

person = Person.new(name: "Alice", age: nil)
p person.valid?
# => false
p person.errors
# => ["age cannot be blank"]

# Example: Calling Private Methods
# private methods cannot be called directly, but `send`` bypasses this restriction.
class Secret
  private

  def whisper
    "This is a secret!"
  end
end

secret = Secret.new
# secret.whisper
# => NoMethodError (private method `whisper' called for an instance of Secret)
p secret.send(:whisper)
# => "This is a secret!"
