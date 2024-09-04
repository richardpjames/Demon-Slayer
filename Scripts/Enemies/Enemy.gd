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
@export var attack_cooldown: float

# For tracking attacks
var _attack_end_time: float = 0

# For tracking state
enum State {IDLE, RUNNING, ATTACKING}
var current_state: State = State.IDLE

# Get a reference to the player as a private variable
@warning_ignore("unused_private_class_variable")
@onready var _player: Player = get_tree().get_first_node_in_group("Player")

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
	if(global_position.distance_to(_player.global_position) < attack_distance && Time.get_ticks_msec() > _attack_end_time):
		if(can_see_player()):
			# Fire the weapon
			weapon.fire(_player.global_position)
			# Reset the cooldown (multiply by 1000 to deal with milliseconds)
			_attack_end_time = Time.get_ticks_msec() + (attack_cooldown * 1000)

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
