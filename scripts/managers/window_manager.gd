extends Node

# Store whether we are full screen or not
var _full_screen: bool = true

# Check for input to switch full screen
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("FullScreen")):
		_full_screen = !_full_screen
		_enter_exit_full_screen()

# To actually enter or exit full screen mode
func _enter_exit_full_screen() -> void:
	if(_full_screen):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
