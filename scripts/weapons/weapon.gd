class_name Weapon
extends Node2D

#Configuration
@export var projectile_scene: PackedScene
@export var fire_point: Marker2D
@export var cooldown_time: float
@export var damage: int

# For managing charges
@export var max_charges: int
# How long before any recharging happens
@export var recharge_cooldown: float
# How long between each recharge point
@export var recharge_interval: float

# Private variables
var _next_recharge_time: float
var _next_recharge_interval: float
var _charges: int
var _player_weapon: bool = false

# Get reference to the player
@onready var _player: Player = get_tree().get_first_node_in_group("Player")

# Private variables
var _end_time: float = 0

func _ready() -> void:
	_charges = max_charges

func _process(_delta: float) -> void:
	_recharge();

# Weapons have the ability to fire
func fire(destination: Vector2) -> void:
	# Stop any recharging
	_next_recharge_time = Time.get_ticks_msec() + (recharge_cooldown * 1000)
	# Check for cooldown
	if(Time.get_ticks_msec() > _end_time && _charges > 0):
		generate_projectiles(destination)
		_end_time = Time.get_ticks_msec() + (cooldown_time * 1000)
		_charges = _charges - 1
		if(_player_weapon):
			SignalManager.on_charges_updated.emit(_charges, max_charges)

# Contains the logic for generating the projectiles (which can be overridde)
func generate_projectiles(destination: Vector2) -> void:
	# Instantiate the projectile
	var projectile = projectile_scene.instantiate()
	# Set the start position to the player
	projectile.global_position = fire_point.global_position
	projectile.set_direction(fire_point.global_position.direction_to(destination).normalized())
	# Set the damage of the projectile
	projectile.set_damage(damage)
	# Attach the projectile to the tree
	get_tree().root.add_child(projectile)
	# Add the cooldown to the current time

# Rotate the weapon so that it is facing the mouse position
func point_at_mouse() -> void:
	look_at(get_global_mouse_position())
# Rotate the weapon so that it is facing the player
func point_at_player() -> void:
	look_at(_player.global_position)

# Recharging the weapon when not in use
func _recharge() -> void:
	# If overall recharging is allowed (time and capacity)
	if(Time.get_ticks_msec() > _next_recharge_time && _charges < max_charges):
		# Can we apply the next charge
		if(Time.get_ticks_msec() > _next_recharge_interval):
			_charges = _charges + 1
			_next_recharge_interval = Time.get_ticks_msec() + (recharge_interval * 1000)
			if(_player_weapon):
				SignalManager.on_charges_updated.emit(_charges, max_charges)

func make_player_weapon() -> void:
	_player_weapon = true

func signal_charges() -> void:
	SignalManager.on_charges_updated.emit(_charges, max_charges)
