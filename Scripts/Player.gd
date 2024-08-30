class_name Player
extends CharacterBody2D

# Configuration variables
@export var health: int
@export var speed: int
@export var attack_cooldown_time: float

# Private variables
var direction: Vector2 = Vector2.DOWN
var facing_direction: Vector2 = Vector2.DOWN
var attack_end_time: float = 0

# For tracking state
enum State {IDLE, RUNNING, ATTACKING}
var current_state: State = State.IDLE

# Called each frame
func _process(delta: float) -> void:
	# Get the player direction from input
	direction = set_direction()
	# Set the player state
	if(velocity != Vector2.ZERO):
		current_state = State.RUNNING
	else:
		current_state = State.IDLE

# Called each physics frame
func _physics_process(delta: float) -> void:
	# Velocity is built into the character controller
	velocity = direction * speed
	# Move the character based on velocity
	move_and_slide()

# Determine the direction to move the player based on input
func set_direction() -> Vector2:
	# Initialise the direction as zero
	var direction = Vector2.ZERO
	# See which buttons are being pressed and set the vector accordingly
	direction.y = Input.get_axis("Up", "Down")
	direction.x = Input.get_axis("Left", "Right")
	# Return the direction
	return direction
