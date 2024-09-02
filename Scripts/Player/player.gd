class_name Player
extends CharacterBody2D

# Configuration variables
@export var health: int
@export var speed: int
@export var attack_cooldown_time: float
@export var projectile_scene: PackedScene
@export var blood_particles: PackedScene
@export var sprites: Node2D
@export var animation_player: AnimationPlayer

# Private variables
var _direction: Vector2 = Vector2.DOWN
var _attack_end_time: float = 0

# For tracking state
enum State {IDLE, RUNNING, ATTACKING, DEAD}
var current_state: State = State.IDLE

# Constants
const SPECIAL_ATTACK_DIRECTIONS = 16

# Called each frame
func _process(_delta: float) -> void:
	# Get the player direction from input if they are not dead
	if(current_state != State.DEAD):
		_direction = _set_direction()
	# Flip the sprite depending on direction to the mouse cursor
	if(_direction.x < 0):
		sprites.scale = Vector2(-1,1)
	if(_direction.x > 0):
		sprites.scale = Vector2(1,1)
	# Set the player state
	if(velocity != Vector2.ZERO):
		current_state = State.RUNNING
	elif(current_state != State.DEAD):
		current_state = State.IDLE
	# Deal with attacking
	_attack()
	# Animate
	_animate()

# Called each physics frame
func _physics_process(_delta: float) -> void:
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
	# Check that previous attacks are complete and player is alive
	if(Time.get_ticks_msec() > _attack_end_time && current_state != State.DEAD):
		# Then check for inputs
		if(Input.is_action_pressed("Fire")):
			# Increment the cooldown timer by the cooldown in milliseconds
			_attack_end_time = Time.get_ticks_msec() + (attack_cooldown_time * 1000)
			# Instantiate the projectile
			var projectile = projectile_scene.instantiate()
			# Set the start position to the player
			projectile.global_position = global_position
			projectile.set_direction(global_position.direction_to(get_global_mouse_position()).normalized())
			# Attach the projectile to the tree
			get_tree().root.add_child(projectile)
		elif(Input.is_action_pressed("SpecialAttack") && GameManager.get_score() > 0):
			# Increment the cooldown timer by the cooldown in milliseconds
			_attack_end_time = Time.get_ticks_msec() + (attack_cooldown_time * 1000)
			# Create projectiles in the specified number of directions
			for i in SPECIAL_ATTACK_DIRECTIONS:
				# Instantiate projectiles
				var projectile = projectile_scene.instantiate()
				# Start at the player
				projectile.global_position = global_position
				# Base the direction on rotating around a circle
				projectile.set_direction(Vector2.ONE.rotated((2 * PI / SPECIAL_ATTACK_DIRECTIONS) * i).normalized())
				# Get additional damage
				projectile.set_damage(3)
				get_tree().root.add_child(projectile)
			# Reduce the score to do this
			SignalManager.on_special_attack_complete.emit()
			
		
# This method provides basics before being overridden by extending classes
func take_damage(damage: int) -> void:
	var new_health: int = GameManager.get_player_health() - damage
	# Emit the signal that we are hit
	SignalManager.on_player_hit.emit(damage)
	# Instantiate the blood particles
	var particles = blood_particles.instantiate()
	# Put it where the projectile was destroyed
	particles.global_position = global_position
	# Add to the root so not attached to this position
	get_tree().root.add_child(particles)
	if(new_health <= 0):
		current_state = State.DEAD
		animation_player.play("Death")

func _animate() -> void:
	if(current_state == State.IDLE):
		animation_player.play("Idle")
	elif(current_state == State.RUNNING):
		animation_player.play("Run")

func signal_game_over() -> void:
	SignalManager.on_game_over.emit()
