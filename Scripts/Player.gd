class_name Player
extends CharacterBody2D

# Configuration variables
@export var health: int
@export var speed: int
@export var attack_cooldown_time: float
@export var projectile_scene: PackedScene

# Private variables
var _direction: Vector2 = Vector2.DOWN
var _facing_direction: Vector2 = Vector2.DOWN
var _attack_end_time: float = 0

# For tracking state
enum State {IDLE, RUNNING, ATTACKING}
var current_state: State = State.IDLE

# Called each frame
func _process(delta: float) -> void:
	# Get the player direction from input
	_direction = _set_direction()
	# Set the player state
	if(velocity != Vector2.ZERO):
		current_state = State.RUNNING
	else:
		current_state = State.IDLE
	# Deal with attacking
	_attack()

# Called each physics frame
func _physics_process(delta: float) -> void:
	# Velocity is built into the character controller
	velocity = _direction * speed
	# Move the character based on velocity
	move_and_slide()

# Determine the direction to move the player based on input
func _set_direction() -> Vector2:
	# Initialise the direction as zero
	var direction = Vector2.ZERO
	# See which buttons are being pressed and set the vector accordingly
	direction.y = Input.get_axis("Up", "Down")
	direction.x = Input.get_axis("Left", "Right")
	# Return the direction
	return direction

func _attack() -> void:
	# Check for the right input and that previous attacks are complete
	if(Input.is_action_pressed("Fire") && Time.get_ticks_msec() > _attack_end_time):
		# Increment the cooldown timer by the cooldown in milliseconds
		_attack_end_time = Time.get_ticks_msec() + (attack_cooldown_time * 1000)
		# Instantiate the projectile
		var projectile = projectile_scene.instantiate()
		# Set the start position to the player
		projectile.global_position = global_position
		projectile.set_direction(global_position.direction_to(get_global_mouse_position()).normalized())
		# Attach the projectile to the tree
		get_tree().root.add_child(projectile)
		
