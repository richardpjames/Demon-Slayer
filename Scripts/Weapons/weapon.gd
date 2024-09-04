class_name Weapon
extends Node2D

#Configuration
@export var projectile_scene: PackedScene
@export var fire_point: Marker2D
@export var cooldown_time: float
@export var damage: int

# Get reference to the player
@onready var _player: Player = get_tree().get_first_node_in_group("Player")

# Private variables
var _end_time: float = 0

# Weapons have the ability to fire
func fire(destination: Vector2) -> void:
	# Check for cooldown
	if(Time.get_ticks_msec() > _end_time):
		generate_projectiles(destination)
		_end_time = Time.get_ticks_msec() + (cooldown_time * 1000)

# Contains the logic for generating the projectiles (which can be overridde)
func generate_projectiles(destination: Vector2) -> void:
	# Instantiate the projectile
	var projectile = projectile_scene.instantiate()
	# Set the start position to the player
	projectile.global_position = fire_point.global_position
	projectile.set_direction(fire_point.global_position.direction_to(destination).normalized())
	# Set the damage of the projectile
	projectile.set_damage(damage)
	# Attach the projectile to the tree
	get_tree().root.add_child(projectile)
	# Add the cooldown to the current time

# Rotate the weapon so that it is facing the mouse position
func point_at_mouse() -> void:
	look_at(get_global_mouse_position())
# Rotate the weapon so that it is facing the player
func point_at_player() -> void:
	look_at(_player.global_position)
