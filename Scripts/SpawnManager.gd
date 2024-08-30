class_name SpawnManager
extends Node2D

# Get a list of all of the spawners so that we can choose randomly
var _spawners: Array[Spawner]

func _ready() -> void:
	# Trigger a new spawn on enemy death
	SignalManager.on_enemy_killed.connect(_spawn_enemy)
	for child in get_children():
		if (child is Spawner):
			_spawners.append(child)
	
func _spawn_enemy() -> void:
	# Spawn an enemy from a random spawner
	_spawners.shuffle()
	# Ensure that we have a spawner
	if(_spawners[0]):
		_spawners[0].spawn()
