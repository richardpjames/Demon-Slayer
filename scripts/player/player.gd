class_name Player
extends CharacterBody2D

# Configuration variables
@export var health: int
@export var speed: int
@export var blood_particles: PackedScene
@export var sprites: Node2D
@export var animation_player: AnimationPlayer
@export var weapon: Weapon
@export var dash_speed: float
@export var dash_time: float
@export var hurt_notifier_scene: PackedScene
@export var directional_light: PointLight2D
@export var invincibility_period: float

# Private variables
var _direction: Vector2 = Vector2.DOWN
var _dash_direction: Vector2 = Vector2.ZERO
var _invincible_until: float = 0

# For tracking state
enum State {IDLE, RUNNING, ATTACKING, DEAD, DASHING}
var current_state: State = State.IDLE

func _ready() -> void:
	SignalManager.on_player_death.connect(_die)
	weapon.make_player_weapon()

# Called each frame
func _process(_delta: float) -> void:
	# Check for dashing first
	_dash()
	# Point our directional light
	directional_light.look_at(get_global_mouse_position())
	# Get the player direction from input if they are not dead
	if(current_state != State.DEAD):
			# Update weapon
		weapon.point_at_mouse()
		_direction = _set_direction()
		# Flip the sprite depending on direction to the mouse cursor
		if(_direction.x < 0):
			sprites.scale = Vector2(-1,1)
		if(_direction.x > 0):
			sprites.scale = Vector2(1,1)
		# Set the player state
		if(velocity != Vector2.ZERO && current_state != State.DASHING):
			current_state = State.RUNNING
		elif(current_state != State.DASHING):
			current_state = State.IDLE
		# Deal with attacking
		_attack()
		# Animate
		_animate()
	else:
		_direction = Vector2.ZERO

# Called each physics frame
func _physics_process(_delta: float) -> void:
	if(current_state == State.DASHING):
		# If dashing use the increased dash speed
		velocity = _direction * dash_speed
	else:
		# Velocity is built into the character controller
		velocity = _direction * speed
	# Move the character based on velocity
	move_and_slide()

# Determine the direction to move the player based on input
func _set_direction() -> Vector2:
	# If we are dashing then return the dash direction
	if(current_state == State.DASHING):
		return _dash_direction
	# Initialise the direction as zero
	var direction = Vector2.ZERO
	# See which buttons are being pressed and set the vector accordingly
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	# Return the direction
	return direction

func _attack() -> void:
	# Check for inputs and player is alive
	if(Input.is_action_pressed("Fire") && current_state != State.DEAD):
		# Increment the cooldown timer by the cooldown in milliseconds
		weapon.fire(get_global_mouse_position())

# This method provides basics before being overridden by extending classes
func take_damage(damage: int) -> bool:
	# If we are dashing then bullets don't hit
	if(current_state == State.DASHING || Time.get_ticks_msec() < _invincible_until):
		return false
	# Emit the signal that we are hit
	SignalManager.on_player_hit.emit(damage)
	# Instantiate the blood particles
	var particles = blood_particles.instantiate()
	# Put it where the projectile was destroyed
	particles.global_position = global_position
	# Add to the root so not attached to this position
	get_tree().root.add_child(particles)
	# Instantiate the hurt notified
	var notifier = hurt_notifier_scene.instantiate()
	# Add to the root so not attached to this position
	get_tree().root.add_child(notifier)
	# Update when we are invincible until
	_invincible_until = Time.get_ticks_msec() + (invincibility_period * 1000)
	# Confirm that damage was taken
	return true

func _die() -> void:
	current_state = State.DEAD
	animation_player.play("Death")

func _animate() -> void:
	if(current_state == State.IDLE):
		animation_player.play("Idle")
	elif(current_state == State.RUNNING):
		animation_player.play("Run")

func idle() -> void:
	current_state = State.IDLE

func signal_game_over() -> void:
	SignalManager.on_game_over.emit()

func _dash() -> void:
	# Check for input and that we are not already dashing
	if(Input.is_action_just_pressed("Dash") && current_state != State.DASHING && current_state != State.DEAD):
		# Determine where we will dash to
		#_dash_direction = (get_global_mouse_position() - global_position).normalized()
		_dash_direction = velocity.normalized()
		# Set out status to prevent other input
		current_state = State.DASHING
		# Wait for the tween to complete and then set to idle
		get_tree().create_timer(dash_time).timeout.connect(idle)

func get_weapon_charges() -> void:
	weapon.signal_charges()
