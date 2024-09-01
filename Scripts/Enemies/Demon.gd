class_name Demon
extends Enemy

# Configuration
@export var damage: int
@export var attack_distance: float
@export var attack_cooldown: float
@export var sprites: Node2D

# Private variables
var _direction: Vector2 = Vector2.ZERO
var _attack_end_time: float = 0

func _process(_delta: float) -> void:
	_direction = _determine_direction()
	# Handle any attacking
	_attack()

func _physics_process(_delta: float) -> void:
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

func _attack() -> void:
	# If the player is close enough and we have finished the cooldown
	if(global_position.distance_to(_player.global_position) < attack_distance && Time.get_ticks_msec() > _attack_end_time):
		# Tween animation of the sprite hitting the player
		var tween = get_tree().create_tween()
		# Tween the sprite to the position of the player and then back again
		tween.tween_property(sprites, "global_position",_player.global_position, 0.15).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(sprites, "global_position", global_position, 0.15).set_trans(Tween.TRANS_QUAD)
		# Attack the player (take damage)
		_player.take_damage(damage)
		# Reset the cooldown (multiply by 1000 to deal with milliseconds)
		_attack_end_time = Time.get_ticks_msec() + (attack_cooldown * 1000)
