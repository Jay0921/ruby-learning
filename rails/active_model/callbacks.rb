require 'active_model'

class Person
  extend ActiveModel::Callbacks

  # Step 1: Define method that you want callbacks attached to.
  define_model_callbacks :save

  # Step 2: Register the callback methods you want to run. Add `before_`, `after_` or `around_` before the method name.
  # Rails runs the callback methods in the order they are defined.
  before_save :append_suffix
  before_save :append_suffix2
  after_save :uppercase_name
  around_save :logging

  def initialize(name:)
    @name = name
  end

  def save
    # Step 3: Wrap the code you want to run the callbacks around in a `run_callbacks` block.
    run_callbacks :save do
      p "Saving the model..."
    end
  end

  private

  def append_suffix
    p "This will run first"
    @name += " Doe"
  end

  def append_suffix2
    p "This will run second"
    @name += " Jr."
  end

  def uppercase_name
    p "This will run fifth"
    @name.upcase!
  end

  def logging
    p "This will run third"
    yield
    p "This will run fourth"
  end
end


person = Person.new(name: "John")
person.save
# "This will run first"
# "This will run second"
# "This will run third"
# "Saving the model..."
# "This will run fourth"
# "This will run fifth"

p person.inspect
# "#<Person:0x000000010b9a0478 @name=\"JOHN DOE JR.\">"
