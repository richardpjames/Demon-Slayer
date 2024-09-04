class_name Enemy
extends CharacterBody2D

# Total health for the character
@export var health : int
# How close they should be to the player before activating
@export var activation_distance: float
# How fast the character can move
@export var speed: int
# For displaying blood particles on getting hurt
@export var blood_particles: PackedScene
# For playing animations
@export var animation_player: AnimationPlayer
# For dropping health packs
@export var health_drop: PackedScene
# For firing weapons
@export var weapon: Weapon
@export var attack_distance: float
# For navigating the environment
@export var navigation_agent: NavigationAgent2D
# For scaling and rotating the image
@export var sprites: Node2D

# For tracking state
enum State {IDLE, RUNNING, ATTACKING}
var current_state: State = State.IDLE

# Private variables
var _activated: bool = false

# Get a reference to the player as a private variable
@onready var _player: Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	# Connect signals from our navigation agent
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func _process(_delta: float) -> void:
	# If we can see the player and they are less than the activation distance then wake up
	if(can_see_player() && global_position.distance_to(_player.global_position) < activation_distance):
		_activated = true
		
	if(_activated && _player.current_state != _player.State.DEAD):
		_set_movement_target(_player.global_position)
		# Flip the sprite depending on direction
		if(velocity.x < 0):
			sprites.scale = Vector2(-1,1)
		if(velocity.x > 0):
			sprites.scale = Vector2(1,1)
		# Set the enemy state
		if(velocity != Vector2.ZERO):
			current_state = State.RUNNING
		else:
			current_state = State.IDLE
		# Handle any attacking
		_attack()
		# Animate
		_animate()

# When our navigation agent has computer velocity, move the enemy
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()

func _physics_process(_delta: float) -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	# Taken from the example documents:
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _set_movement_target(target: Vector2):
	navigation_agent.set_target_position(target)

func _animate() -> void:
	if(current_state == State.IDLE):
		animation_player.play("Idle")
	elif(current_state == State.RUNNING):
		animation_player.play("Run")

# This method provides basics before being overridden by extending classes
func take_damage(damage: int) -> bool:
		# Subtract the amount of damage from health (set in Enemy class)
	health -= damage
	# Instantiate the blood particles
	var particles = blood_particles.instantiate()
	# Put it where the projectile was destroyed
	particles.global_position = global_position
	# Add to the root so not attached to this position
	get_tree().root.add_child(particles)
	# Determine whether to die
	if(health <= 0):
		_drop_item()
		queue_free()
		SignalManager.on_enemy_killed.emit()
	# Confirm that damage was taken
	return true

func can_see_player() -> bool:
		# Check if there is clear line of sight to the player
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		# Perform a ray trace masked to "2"
		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, _player.global_position, 2)
		var result: Dictionary = space_state.intersect_ray(query)
		# If we hit something - check if it is the player and return the direction
		if(result):
			if(result["collider"].is_in_group("Player")):
				return true
		# If we have not hit something, or it is not the player
		return false

func _attack() -> void:
	# If the player is close enough and we have finished the cooldown
	if(global_position.distance_to(_player.global_position) < attack_distance):
		if(can_see_player()):
			# Fire the weapon
			weapon.fire(_player.global_position)

func _drop_item() -> void:
	var rng = RandomNumberGenerator.new()
	# 1 in 4 chance of dropping health
	if(rng.randi_range(1,4) == 1):
		# Instantiate health drop
		var drop = health_drop.instantiate()
		# Place where the enemy died
		drop.global_position = global_position
		# Add to the scene tree
		get_tree().root.call_deferred("add_child",drop)
