class_name Projectile
extends Area2D

# Configuration options
@export var speed: int
@export var lifetime: float
@export var particles: PackedScene
@export var damage: int

@export var group_to_damage: String
@export var group_to_ignore: String

# Direction of travel
var _direction: Vector2 = Vector2.ZERO

# Private variables
var _expiry_time: float

func _ready() -> void:
	# Set the time at which we will destroy the object (converting lifetime to milliseconds)
	_expiry_time = Time.get_ticks_msec() + (lifetime * 1000)
	# Attack the on_body_entered to the signal
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	# If the expiry time has passed then destroy the object
	if(Time.get_ticks_msec() > _expiry_time):
		queue_free()

# Update the projectile position each frame
func _physics_process(delta: float) -> void:
	global_position += _direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if(!body.is_in_group(group_to_ignore)):
		# Damage any enemies
		var success: bool = false
		if(body.is_in_group(group_to_damage)):
			success = body.take_damage(damage)
		if(success || !body.is_in_group(group_to_damage)):
			# Instantiate the splash particles
			var splash = particles.instantiate()
			# Put it where the projectile was destroyed
			splash.global_position = global_position
			# Add to the root so not attached to this position
			get_tree().root.add_child(splash)
			# Destroy this object
			queue_free()

func set_direction(new_direction: Vector2) -> void:
	_direction = new_direction
	look_at((global_position + _direction))

func set_damage(new_damage: int) -> void:
	damage = new_damage
