extends Node

# Private variables
var _max_health: int = 10
var _health: int
var _score: int = 0

# Scenes which are required - main menu, game over and main level
const START_GAME = preload("res://Scenes/Levels/demo_scene.tscn")
const MAIN_MENU = preload("res://Scenes/UI/main_menu.tscn")
const GAME_OVER = preload("res://Scenes/UI/game_over.tscn")

# Connect to signals to deal with events in the game
func _ready() -> void:
	SignalManager.on_player_hit.connect(_take_damage)
	SignalManager.on_player_healed.connect(_heal)
	SignalManager.on_game_over.connect(_game_over)
	SignalManager.on_game_start.connect(_start_game)
	SignalManager.on_main_menu_requested.connect(_main_menu)
	SignalManager.on_enemy_killed.connect(_increase_score)
	SignalManager.on_special_attack_complete.connect(_decrease_score)

# Reset stats to put health back to max
func _reset_game() -> void:
	_health = _max_health
	_score = 0
	SignalManager.on_player_health_updated.emit(_health)
	SignalManager.on_score_updated.emit(_score)
	
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
	# Reduce health by damage
	_health = _health - damage
	print(_health)
	# Let the UI etc. know that the health has changed
	SignalManager.on_player_health_updated.emit(_health)
	if(_health <= 0):
		SignalManager.on_player_death.emit()

func _heal() -> void:
	if(_health < _max_health):
		_health = _health + 1
		print(_health)
	# Let the UI etc. know that the health has changed
	SignalManager.on_player_health_updated.emit(_health)

# Allow direct access to health if needed
func get_player_health() -> int:
	return _health

# Detect the escape key and return to main menu
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("MainMenu")):
		_main_menu()
		
func get_score() -> int:
	return _score
		
# Increase the score and emit a signal to confirm
func _increase_score() -> void:
	_score = _score + 1
	SignalManager.on_score_updated.emit(_score)
	
# Decrease the score and emit a signal to confirm
func _decrease_score() -> void:
	_score = _score - 1
	SignalManager.on_score_updated.emit(_score)
