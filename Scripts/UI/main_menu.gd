class_name MainMenu
extends Control

# Configuration
@export var play_button: Button

func _ready() -> void:
	play_button.pressed.connect(_start_game)
	
func _start_game() -> void:
	SignalManager.on_game_start.emit()
