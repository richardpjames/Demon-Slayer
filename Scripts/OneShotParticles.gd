class_name OneShotParticles
extends GPUParticles2D

func _ready() -> void:
	# Connect the finished signal and start emitting
	finished.connect(_on_finished)
	one_shot = true
	emitting = true
	
# These are one shot particles, so destroy them when finished
func _on_finished() -> void:
	queue_free()
