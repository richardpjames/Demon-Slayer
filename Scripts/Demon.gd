class_name Demon
extends Enemy

# Private variables
var _direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	_direction = _determine_direction()

func _physics_process(delta: float) -> void:
		velocity = _direction * speed
		move_and_slide()

func _determine_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	# Determine how far away we are from the player
	var distance_to_player: float = global_position.distance_to(_player.global_position)
	# If we are within distance then we want to walk towards the player
	if(distance_to_player < activation_distance):
		# Check if there is clear line of sight to the player
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		# Perform a ray trace masked to "2"
		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, _player.global_position, 2)
		var result: Dictionary = space_state.intersect_ray(query)
		# If we hit something - check if it is the player and return the direction
		if(result):
			if(result["collider"].is_in_group("Player")):
				return (_player.global_position - global_position).normalized()
	# Otherwise return zero (player not hit or not within distance
	return direction
