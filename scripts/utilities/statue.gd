class_name Statue
extends Node2D

# Hold the parent node for all enemies for this statue
@export var enemies: Node2D
@export var animation_player: AnimationPlayer

func _process(_delta: float) -> void:
	# If there are no enemies left under the node then remove the statue
	if(enemies.get_child_count() == 0):
		animation_player.play("Destroy")
