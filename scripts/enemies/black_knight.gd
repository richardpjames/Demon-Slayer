class_name BlackKnight
extends Enemy

# For keeping track of attack states
enum Phase {ONE, TWO, THREE}
var current_phase: Phase = Phase.ONE

# Determine which attack phase based on health
func _process(delta: float) -> void:
	if (health <= 10):
		current_phase = Phase.THREE
	elif (health <= 20):
		current_phase = Phase.TWO
	else:
		current_phase = Phase.ONE
	super(delta)

func _attack() -> void:
	# If the player is close enough and we have finished the cooldown
	if (global_position.distance_to(_player.global_position) < attack_distance):
		if (can_see_player()):
			# Fire the weapon
			if(current_phase == Phase.ONE):
				weapon.cooldown_time = 2
			if(current_phase == Phase.TWO):
				weapon.cooldown_time = 4
			if(current_phase == Phase.THREE):
				weapon.cooldown_time = 2
			weapon.fire_phased(current_phase)
