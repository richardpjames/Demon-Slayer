class_name MainMenu
extends Control

# Configuration
@export var play_button: Button
@export var quit_button: Button

func _ready() -> void:
	play_button.pressed.connect(_start_game)
	quit_button.pressed.connect(_quit_game)
	
func _start_game() -> void:
	SignalManager.on_game_start.emit()

func _quit_game() -> void:
	get_tree().quit()
