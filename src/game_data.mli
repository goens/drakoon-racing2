(* Data structures *)

type player_t = {
  position : Raylib.Vector2.t;
  orientation : Raylib.Vector2.t;
  speed : float;
  damage : int;
  invulnerability : float;
}

type env_item_t = {
  box : Raylib.Rectangle.t;
  colliding : bool;
  color : Raylib.Color.t;
}

type camera_mode_t =
  | Center
  | CenterInsideMap
  | SmoothFollow

type state_t = player_t * env_item_t List.t * Raylib.Camera2D.t * camera_mode_t

val window_width : int
val window_height : int
val player_max_speed : float
val player_max_reverse_speed : float
val player_max_damage : int
val player_rotation_speed : float
val player_acceleration : float
val player_invulnerability_time : float
val game_target_fps : int
val world_street_drag : float
val world_min_items : int
val world_max_items : int
val world_width : int
val world_height : int
val smooth_min_speed : float
val smooth_min_length : float
val smooth_fraction : float
val bbox_x : float
val bbox_y : float

val half_screen : Raylib.Vector2.t
