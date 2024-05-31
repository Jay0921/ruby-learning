require 'active_model'

# ActiveModel::Dirty allows you to track changes in your model.

class Person
  include ActiveModel::Dirty

  # Define the attribute you want to track changes for.
  define_attribute_methods :first_name, :last_name

  def initialize(first_name: nil, last_name: nil)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_name
    @first_name
  end

  def last_name
    @last_name
  end

  def first_name=(val)
    # `<attribute>_will_change!` will mark the attribute as changed.
    # Without calling these methods, the changes information won't be available.
    first_name_will_change! unless val == @first_name
    @first_name = val
  end

  def last_name=(val)
    last_name_will_change! unless val == @last_name
    @last_name = val
  end

  def save
    # Calling `changes_applied` will clear the changes information.
    changes_applied
  end

  def reload!
    clear_changes_information
  end

  def rollback!
    restore_attributes
  end
end

person = Person.new(first_name: "John", last_name: "Doe")
person.first_name = "Jane"
person.last_name = "Smith"
person.first_name = "Alice"
person.last_name = "Brown"


# =====================================================
# Available methods before `changes_applied` is called.
# =====================================================
# `<attribute>_changed?` returns true if the attribute has changed.
p "person.first_name_changed?: #{person.first_name_changed?}"
# true
p "person.last_name_changed?: #{person.last_name_changed?}"
# true

# `<attribute>_was` returns the original value of the attribute.
p "person.first_name_was: #{person.first_name_was}"
# "John"
p "person.last_name_was: #{person.last_name_was}"
# "Doe"

# `<attribute>_change` returns an array with the original value and the new value of the attribute.
p "person.first_name_change: #{person.first_name_change}"
# ["John", "Alice"]
p "person.last_name_change: #{person.last_name_change}"
# ["Doe", "Brown"]

# `changes` returns a hash with the attribute first_name as the key and an array with the original value and the new value as the value.
p "person.changes: #{person.changes}"
# {"first_name"=>["John", "Alice"], "last_name"=>["Doe", "Brown"]}

# `restore_<attribute>!` will restore the original value of the attribute.
person.restore_first_name!
p "person.restore_first_name!: #{person.first_name}"
# "John"
p "person.first_name_changed?: #{person.first_name_changed?}"
# false

# `clear_<attribute>_change` will clear the changes information for <attribute>, but the changes are still there.
# <attribute>_changed?, `<attribute>_was` and `changes` won't return any information for <attribute>.
person.clear_last_name_change
p "person.last_name_changed?: #{person.last_name_changed?}"
# false
p "person.last_name_was: #{person.last_name_was}"
# Brown
p "person.last_name_change: #{person.last_name_change}"
# nil

p "person.full_name: #{person.full_name}"
# John Brown

p "====================================================================="

# =====================================================
# person instance with `rollback!` method.
# =====================================================

person = Person.new(first_name: "John", last_name: "Doe")
person.first_name = "Jane"
person.last_name = "Smith"
person.first_name = "Alice"
person.last_name = "Brown"

# rollback! will restore the attributes to their original values.
p "person.full_name: #{person.full_name}"
# Alice Brown
person.rollback!
p "person.full_name: #{person.full_name}"
# John Doe
p "person.first_name_changed?: #{person.first_name_changed?}"
# false
p "person.first_name_was: #{person.first_name_was}"
# John
p "person.first_name_change: #{person.first_name_change}"
# nil
p "person.changes: #{person.changes}"
# {}

p "====================================================================="

# =====================================================
# Available methods After `changes_applied` is called.
# =====================================================
person = Person.new(first_name: "John", last_name: "Doe")
person.first_name = "Jane"
person.last_name = "Smith"
person.first_name = "Alice"
person.last_name = "Brown"
person.save

# `<attribute>_previous_change` returns the old and the new value of the attribute before the last save.
p "person.first_name_previous_change: #{person.first_name_previous_change}"
# ["John", "Alice"]
p "person.last_name_previous_change: #{person.last_name_previous_change}"
# ["Doe", "Brown"]

# `<attribute>_previously_changed?` methods will return true if the attribute has changed.
p "person.first_name_previously_changed?: #{person.first_name_previously_changed?}"
# true
p "person.first_name_previously_changed?(from: 'John', to: 'Jane'): #{person.first_name_previously_changed?(from: 'John', to: 'Alice')}"
# true
p "person.last_name_previously_changed?: #{person.last_name_previously_changed?}"
# true
p "person.last_name_previously_changed?(from: 'Doe', to: 'Smith'): #{person.last_name_previously_changed?(from: 'Doe', to: 'Brown')}"
# true

# `<attribute>_previously_was` returns the old value of the attribute before the last save.
p "person.first_name_previously_was: #{person.first_name_previously_was}"
# "John"
p "person.last_name_previously_was: #{person.last_name_previously_was}"
# "Doe"

# `previous_changes` returns a hash with the attribute as the key and an array with the old value and the new value as the value.
p "person.previous_changes: #{person.previous_changes}"
# {"first_name"=>["John", "Alice"], "last_name"=>["Doe", "Brown"]}

p "====================================================================="

person = Person.new(first_name: "John", last_name: "Doe")
person.first_name = "Jane"
person.last_name = "Smith"
person.first_name = "Alice"
person.last_name = "Brown"

p "person.full_name: #{person.full_name}"
# Alice Brown

p "person.first_name_changed?: #{person.first_name_changed?}"
# true
p "person.last_name_changed?: #{person.last_name_changed?}"
# true

p "person.first_name_was: #{person.first_name_was}"
# "John"
p "person.last_name_was: #{person.last_name_was}"
# "Doe"

p "person.changes: #{person.changes}"
# {"first_name"=>["John", "Alice"], "last_name"=>["Doe", "Brown"]}

# `reload!` will clear the changes information. But the changes are still there.
person.reload!

p "person.first_name_changed?: #{person.first_name_changed?}"
# false
p "person.last_name_changed?: #{person.last_name_changed?}"
# false

p "person.first_name_was: #{person.first_name_was}"
# "Alice"
p "person.last_name_was: #{person.last_name_was}"
# "Brown"

p "person.changes: #{person.changes}"
# {}
