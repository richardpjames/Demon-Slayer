class_name BlackKnightWeapon
extends Weapon

# Constants
const ATTACK_DIRECTIONS_1: int = 4  
const ATTACK_DIRECTIONS_2: int = 16
const ATTACK_DIRECTIONS_3: int = 32

# Three different attack phases
func fire_phased(phase: BlackKnight.Phase) -> void:
    # This weapon adds more attack directions with phase
    var attack_directions: int = 0
    if(phase == BlackKnight.Phase.ONE):
        attack_directions = ATTACK_DIRECTIONS_1
    if(phase == BlackKnight.Phase.TWO):
        attack_directions = ATTACK_DIRECTIONS_2
    if(phase == BlackKnight.Phase.THREE):
        attack_directions = ATTACK_DIRECTIONS_3

    # Fires in a circular pattern
    if(Time.get_ticks_msec() > _end_time && _charges > 0):
        # Create projectiles in the specified number of directions
        for i in attack_directions:
            # Instantiate projectiles
            var projectile = projectile_scene.instantiate()
            # Start at the player
            projectile.global_position = fire_point.global_position
            # Base the direction on rotating around a circle
            projectile.set_direction(Vector2.ONE.rotated((2 * PI / attack_directions) * i).normalized())
            # Get additional damage
            projectile.set_damage(damage)
            get_tree().root.add_child(projectile)
            _end_time = Time.get_ticks_msec() + (cooldown_time * 1000)