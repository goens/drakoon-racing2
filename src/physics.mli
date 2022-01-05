open Game_data

val update_player_velocity : Raylib.Vector2.t -> player_t -> player_t
val update_player_position : float -> env_item_t List.t -> player_t -> player_t
