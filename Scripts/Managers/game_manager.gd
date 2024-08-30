extends Node

# Private variables
var _max_health: int = 10
var _health: int
# Scenes which are required - main menu, game over and main level
const START_GAME = preload("res://Scenes/demo_scene.tscn")
const MAIN_MENU = preload("res://Scenes/main_menu.tscn")
const GAME_OVER = preload("res://Scenes/game_over.tscn")

# Connect to signals to deal with events in the game
func _ready() -> void:
	SignalManager.on_player_hit.connect(_take_damage)
	SignalManager.on_player_death.connect(_game_over)
	SignalManager.on_game_start.connect(_start_game)
	SignalManager.on_main_menu_requested.connect(_main_menu)

# Reset stats to put health back to max
func _reset_game() -> void:
	_health = _max_health
	
# Start the game by resetting statistics and loading the game scene
func _start_game() -> void:
	_reset_game()
	# Call deferred to ensure all other processing complete
	get_tree().call_deferred("change_scene_to_packed", START_GAME)

# Show the game over screen on player death
func _game_over() -> void:
	# Call deferred to ensure all other processing complete
	get_tree().call_deferred("change_scene_to_packed", GAME_OVER)

# Show the main menu when requested
func _main_menu() -> void:
	# Call deferred to ensure all other processing complete
	get_tree().call_deferred("change_scene_to_packed", MAIN_MENU)

func _take_damage(damage: int) -> void:
	_health = _health - damage
	# Let the UI etc. know that the health has changed
	SignalManager.on_player_health_updated.emit(_health)
	if(_health <= 0):
		SignalManager.on_player_death.emit()
