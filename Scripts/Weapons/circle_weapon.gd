class_name CircleWeapon
extends Weapon

# Constants
const ATTACK_DIRECTIONS = 16

# Fires projectiles in a circle from the fire point
func fire(_destination: Vector2) -> void:
	# Create projectiles in the specified number of directions
	for i in ATTACK_DIRECTIONS:
		# Instantiate projectiles
		var projectile = projectile_scene.instantiate()
		# Start at the player
		projectile.global_position = fire_point.global_position
		# Base the direction on rotating around a circle
		projectile.set_direction(Vector2.ONE.rotated((2 * PI / ATTACK_DIRECTIONS) * i).normalized())
		# Get additional damage
		projectile.set_damage(3)
		get_tree().root.add_child(projectile)
