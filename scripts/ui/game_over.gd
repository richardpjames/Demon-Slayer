class_name GameOver
extends Control

# Configuration
@export var menu_button: Button

func _ready() -> void:
	menu_button.pressed.connect(_main_menu)
	
func _main_menu() -> void:
	SignalManager.on_main_menu_requested.emit()
