class_name Weapon
extends Node2D

#Configuration
@export var projectile_scene: PackedScene
@export var fire_point: Marker2D

# Get reference to the player
@onready var _player: Player = get_tree().get_first_node_in_group("Player")


# Weapons have the ability to fire
func fire(destination: Vector2) -> void:
	# Instantiate the projectile
	var projectile = projectile_scene.instantiate()
	# Set the start position to the player
	projectile.global_position = fire_point.global_position
	projectile.set_direction(fire_point.global_position.direction_to(destination).normalized())
	# Attach the projectile to the tree
	get_tree().root.add_child(projectile)

# Rotate the weapon so that it is facing the mouse position
func point_at_mouse() -> void:
	look_at(get_global_mouse_position())
# Rotate the weapon so that it is facing the player
func point_at_player() -> void:
	look_at(_player.global_position)
