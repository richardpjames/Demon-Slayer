class_name GameCamera
extends Camera2D

# Configuration variables
@export var shake_intensity: int
@export var shake_intensity_small: int
@export var shake_duration: float
@export var offset_scale: float

# Private variables
var _noise: FastNoiseLite

# Initialise the noise on ready
func _ready() -> void:
	_noise = FastNoiseLite.new()
	# Shake the camera when the following signals are emitted
	SignalManager.on_player_hit.connect(shake_large)
	SignalManager.on_enemy_hit.connect(shake_small)

func _process(_delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var screen_center: Vector2 = get_screen_center_position()
	# Offset the screen based on the relative positions
	var x: float = (mouse_position.x - screen_center.x) * offset_scale
	var y: float = (mouse_position.y - screen_center.y) * offset_scale
	position = Vector2(x,y)

func shake_large(_damage: int) -> void:
	# Tween between the maximum intensity to zero over the duration
	var shake_tween: Tween = get_tree().create_tween()
	shake_tween.tween_method(apply_noise, shake_intensity ,0, shake_duration)

func shake_small() -> void:
	# Tween between the maximum intensity to zero over the duration
	var shake_tween: Tween = get_tree().create_tween()
	shake_tween.tween_method(apply_noise, shake_intensity_small ,0, shake_duration)

# Apply a random noise to the camera - to be used in tweening
@warning_ignore("unused_parameter")
func apply_noise(intensity: float) -> void:
	var camera_offset: float = _noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	offset = Vector2(camera_offset, camera_offset)
	
