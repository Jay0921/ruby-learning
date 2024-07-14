# Double dispatch is a technique used in object-oriented programming to determine which method to call at runtime based on the types of two objects involved in the interaction. This is particularly useful when the behavior of a method depends on the runtime types of both the objects.

# Let's consider a simple example of a game where we have three types of objects: Player, Enemy, and Wall. Each object can collide with another object, and the behavior of the collision depends on the types of the objects involved.

# First, let's try to implement the collision logic without using double dispatch:
# =====================================================
# Without Double Dispatch Implementation
# =====================================================
class GameObject
  def collide_with(other)
    case other.class.name
    when "Player"
      collide_with_player(other)
    when "Enemy"
      collide_with_enemy(other)
    when "Wall"
      collide_with_wall(other)
    when "Coin"
      collide_with_coin(other)
    end
  end
end

class Player < GameObject
  def collide_with_player(player)
    "Player collides with another Player"
  end

  def collide_with_enemy(enemy)
    "Player collides with Enemy"
  end

  def collide_with_wall(wall)
    "Player collides with Wall"
  end

  def collide_with_coin(coin)
    "Player collects Coin"
  end
end

class Enemy < GameObject
  def collide_with_player(player)
    "Enemy collides with Player"
  end

  def collide_with_enemy(enemy)
    "Enemy collides with another Enemy"
  end

  def collide_with_wall(wall)
    "Enemy collides with Wall"
  end
end

class Wall < GameObject
  def collide_with_player(player)
    "Wall collides with Player"
  end

  def collide_with_enemy(enemy)
    "Wall collides with Enemy"
  end

  def collide_with_wall(wall)
    "Wall collides with another Wall"
  end
end

class Coin < GameObject
end

player = Player.new
enemy = Enemy.new
wall = Wall.new
coin = Coin.new

puts player.collide_with(enemy) # => Player collides with Enemy
puts enemy.collide_with(wall)   # => Enemy collides with Wall
puts wall.collide_with(player)  # => Wall collides with Player
puts player.collide_with(coin)  # => Player collects Coin

# Another thing to highlight is that the Coin object can only collide with the Player object. However, we still need to add type checking inside the GameObject class to handle collisions with the Coin object. As the number of objects grows, this approach will become harder to maintain and extend.

# Pros:
# - Simplicity: This approach is straightforward and easy to understand.
# - Direct Handling: Each object type directly handles collisions with other types, reducing the need for additional layers/methods.

# Cons:
# - Scalability: Adding new types of objects requires modifying the collide_with method to handle the new type, which violates the Open/Closed Principle.
# - Type Checking: It relies on type checking (other.class.name), which can be error-prone and harder to manage as the number of types grows.



# Now, let's implement the collision logic using double dispatch:
# =====================================================
# Double Dispatch Implementation
# =====================================================
class GameObject2
  def collide_with(other)
    other.collide_with_game_object(self)
  end

  def collide_with_game_object(game_object)
    raise NotImplementedError, 'This method should be overridden in subclasses'
  end
end

class Player2 < GameObject2
  def collide_with_game_object(game_object)
    game_object.collide_with_player(self)
  end

  def collide_with_player(player)
    "Player collides with another Player"
  end

  def collide_with_enemy(enemy)
    "Player collides with Enemy"
  end

  def collide_with_wall(wall)
    "Player collides with Wall"
  end

  def collide_with_coin(coin)
    "Player collects Coin"
  end
end

class Enemy2 < GameObject2
  def collide_with_game_object(game_object)
    game_object.collide_with_enemy(self)
  end

  def collide_with_player(player)
    "Enemy collides with Player"
  end

  def collide_with_enemy(enemy)
    "Enemy collides with another Enemy"
  end

  def collide_with_wall(wall)
    "Enemy collides with Wall"
  end
end

class Wall2 < GameObject2
  def collide_with_game_object(game_object)
    game_object.collide_with_wall(self)
  end

  def collide_with_player(player)
    "Wall collides with Player"
  end

  def collide_with_enemy(enemy)
    "Wall collides with Enemy"
  end

  def collide_with_wall(wall)
    "Wall collides with another Wall"
  end
end

class Coin2 < GameObject2
  def collide_with_game_object(game_object)
    game_object.collide_with_coin(self)
  end
end

# Usage example
player2 = Player2.new
enemy2 = Enemy2.new
wall2 = Wall2.new
coin2 = Coin2.new

puts player2.collide_with(enemy2) # => Player2 collides with Enemy2
puts enemy2.collide_with(wall2)   # => Enemy2 collides with Wall2
puts wall2.collide_with(player2)  # => Wall2 collides with Player2
puts player2.collide_with(coin2)  # => Player2 collects Coin2

# With double dispatch approach, we don't need to maintain a list of object types inside the GameObject class. Compared to the previous implementation, if the coin object only collides with the player object, we can simply add a new method to the Player2 class without modifying any other classes.

# Pros:
# - No Type Checking: Avoids explicit type checking, relying instead on polymorphism to resolve the correct method to call.
# - Extensibility: New object types can be added with minimal changes to existing code. New visitor methods can handle new types without modifying existing collision methods.

# Cons:
# - Introduces an additional layer of method calls, which can be harder to follow.
# - Boilerplate Code: Requires additional methods (collide_with_game_object in this case) to handle the double dispatch logic.
