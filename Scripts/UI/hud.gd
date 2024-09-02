class_name HUD
extends CanvasLayer

# Configuration
@export var hearts_container: HBoxContainer
@export var full_heart_scene: PackedScene
@export var score_label: Label

# Connect signals
func _ready() -> void:
	SignalManager.on_player_health_updated.connect(_update_hearts)
	SignalManager.on_score_updated.connect(_update_score)
	_update_hearts(GameManager.get_player_health())
	
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

func _update_score(score: int) -> void:
	score_label.text = str(score)

# To quit the game, request the main menu
func _quit_game() -> void:
	SignalManager.on_main_menu_requested.emit()
