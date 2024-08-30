class_name Spawner
extends Marker2D

# Configuration
@export var monster_scene: PackedScene
@export var monster_node: Node2D

func spawn() -> void:
	# Instantiate the scene with the monster
	var monster = monster_scene.instantiate()
	# Set the correct position
	monster.global_position = global_position
	# Add into the scene tree in the correct place
	monster_node.call_deferred("add_child", monster)
