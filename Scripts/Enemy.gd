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

# Get a reference to the player as a private variable
@onready var _player: Player = get_tree().get_first_node_in_group("Player")

# This method provides basics before being overridden by extending classes
func take_damage(damage: int) -> void:
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
		queue_free()
