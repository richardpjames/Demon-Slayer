extends Node

@warning_ignore("unused_signal")
signal on_player_hit(damage: int)
@warning_ignore("unused_signal")
signal on_enemy_hit()
@warning_ignore("unused_signal")
signal on_player_healed()
@warning_ignore("unused_signal")
signal on_player_death()
@warning_ignore("unused_signal")
signal on_player_health_updated(health: int)
@warning_ignore("unused_signal")
signal on_score_updated(score)
@warning_ignore("unused_signal")
signal on_enemy_killed
@warning_ignore("unused_signal")
signal on_game_start
@warning_ignore("unused_signal")
signal on_main_menu_requested
@warning_ignore("unused_signal")
signal on_game_over
@warning_ignore("unused_signal")
signal on_charges_updated(charges: int, max_charges: int)
