class_name HUD
extends CanvasLayer

# Configuration
@export var hearts_container: HBoxContainer
@export var full_heart_scene: PackedScene
@export var quit_button: Button

# Connect signals
func _ready() -> void:
	SignalManager.on_player_health_updated.connect(_update_hearts)
	_update_hearts(GameManager.get_player_health())
	quit_button.pressed.connect(_quit_game)
	
func _update_hearts(health: int) -> void:
	# Delete all of the existing hearts
	var children = hearts_container.get_children()
	# Loop through each and remove
	for child in children:
		child.free()
	# Now add the correct number of hearts
	for i in range(health):
		var heart = full_heart_scene.instantiate()
		hearts_container.add_child(heart)

# To quit the game, request the main menu
func _quit_game() -> void:
	SignalManager.on_main_menu_requested.emit()
