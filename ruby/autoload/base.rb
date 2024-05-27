# References:
# https://medium.com/rubycademy/the-autoload-method-in-ruby-11fd079562ef
# Make sure to execute this file in this directory, otherwise it won't work!
# The autoload method is used to load a module when it is first accessed.

module Test
  autoload(:A, './a.rb')

  # The autoload method adds module into internal hash table
  p constants
  # [:A]

  p "The A module isn't yet loaded!"
  # The module A only loaded when we explicitly call it.
  A
  p "The A module has been successfully loaded!"

  # The :A constant is now removed from the internal hash table after it has been loaded
  p constants
  # []
end
