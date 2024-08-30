class_name GameCamera
extends Camera2D

# Configuration variables
@export var shake_intensity: int
@export var shake_duration: float

# Private variables
var noise: FastNoiseLite

# Initialise the noise on ready
func _ready() -> void:
	noise = FastNoiseLite.new()
	# Shake the camera when the following signals are emitted
	SignalManager.on_player_hit.connect(shake)

func shake() -> void:
	# Tween between the maximum intensity to zero over the duration
	var shake_tween: Tween = get_tree().create_tween()
	shake_tween.tween_method(apply_noise, shake_intensity ,0, shake_duration)

# Apply a random noise to the camera - to be used in tweening
func apply_noise(intensity: float) -> void:
	var camera_offset: float = noise.get_noise_1d(Time.get_ticks_msec()) * shake_intensity
	offset = Vector2(camera_offset, camera_offset)
