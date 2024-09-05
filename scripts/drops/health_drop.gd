class_name HealthDrop
extends Area2D


func _ready() -> void:
	body_entered.connect(_heal_player)
	
func _heal_player(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		SignalManager.on_player_healed.emit()
		queue_free()
