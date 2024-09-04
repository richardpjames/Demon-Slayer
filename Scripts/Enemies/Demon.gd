class_name Demon
extends Enemy

# Configuration
@export var sprites: Node2D

# Private variables
var _direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if(_player.current_state != _player.State.DEAD):
		#Rotate the weapon
		weapon.point_at_player()
		_direction = _determine_direction()
		# Flip the sprite depending on direction
		if(_direction.x < 0):
			sprites.scale = Vector2(-1,1)
		if(_direction.x > 0):
			sprites.scale = Vector2(1,1)
		# Set the demons state
		if(current_state == State.ATTACKING):
			pass
		elif(velocity != Vector2.ZERO):
			current_state = State.RUNNING
		else:
			current_state = State.IDLE
		# Handle any attacking
		_attack()
		# Animate
		_animate()

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
		if(can_see_player()):
			return (_player.global_position - global_position).normalized()
	# Otherwise return zero (player not hit or not within distance
	return direction

func _animate() -> void:
	if(current_state == State.IDLE):
		animation_player.play("Idle")
	elif(current_state == State.RUNNING):
		animation_player.play("Run")
