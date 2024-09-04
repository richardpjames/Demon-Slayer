class_name HUD
extends CanvasLayer

# Configuration
@export var hearts_container: HBoxContainer
@export var full_heart_scene: PackedScene
@export var empty_heart_scene: PackedScene
@export var charges_container: HBoxContainer
@export var full_charge_scene: PackedScene
@export var empty_charge_scene: PackedScene
@export var score_label: Label

# Reference to the player
@onready var _player: Player = get_tree().get_first_node_in_group("Player")

# Connect signals
func _ready() -> void:
	SignalManager.on_player_health_updated.connect(_update_hearts)
	SignalManager.on_score_updated.connect(_update_score)
	SignalManager.on_charges_updated.connect(_update_charges)
	_update_hearts(GameManager.get_player_health())
	_player.get_weapon_charges()
	
	
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
	for i in range(max(health,0), GameManager._max_health):
		var heart = empty_heart_scene.instantiate()
		hearts_container.add_child(heart)

func _update_charges(charges: int, max_charges: int) -> void:
	# Delete all of the existing charges
	var children = charges_container.get_children()
	# Loop through each and remove
	for child in children:
		child.free()
	# Now add the correct number of hearts
	for i in range(charges):
		var charge = full_charge_scene.instantiate()
		charges_container.add_child(charge)
	for i in range(charges, max_charges):
		var charge = empty_charge_scene.instantiate()
		charges_container.add_child(charge)

func _update_score(score: int) -> void:
	score_label.text = str(score)

# To quit the game, request the main menu
func _quit_game() -> void:
	SignalManager.on_main_menu_requested.emit()
