open Game_data

val update_player_velocity : Raylib.Vector2.t -> bool -> player_t -> player_t
val update_player_position : float -> env_item_t List.t -> bool -> player_t -> player_t
val calculate_angle_deg : Raylib.Vector2.t -> Raylib.Vector2.t -> float option
val to_polar_coords : Raylib.Vector2.t  -> float * float (* in degrees, basing the origin at 0. -1.0 *)
val from_polar_coords :  float * float -> Raylib.Vector2.t (* in degrees, basing the origin at 0. -1.0 *)
val deg2rad : float -> float
val rad2deg : float -> float
val check_collisions : player_t -> env_item_t List.t -> bool -> player_t * env_item_t List.t * bool

