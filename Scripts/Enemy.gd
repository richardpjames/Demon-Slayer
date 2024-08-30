class_name Enemy
extends CharacterBody2D

# Total health for the character
@export var health : int
# How close they should be to the player before activating
@export var activation_distance: float
# How fast the character can move
@export var speed: int

# Get a reference to the player as a private variable
@onready var _player: Player = get_tree().get_first_node_in_group("Player")
