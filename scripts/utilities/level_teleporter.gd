class_name LevelTeleporter
extends Area2D

@export var level: PackedScene
@export var start_position: Vector2

# Connect the function for requesting a level
func _ready() -> void:
    body_entered.connect(_request_level)

func _request_level(body: Node2D) -> void:
    # Check if the body entering is a player
    if(body.is_in_group("Player")):
        SignalManager.on_new_level_requested.emit(level, start_position)