(* Data structures *)

type player_t = {
  position : Raylib.Vector2.t;
  orientation : Raylib.Vector2.t;
  speed : float;
  damage : int
}

type env_item_t = {
  box : Raylib.Rectangle.t;
  blocking : bool;
  color : Raylib.Color.t;
}

type camera_mode_t =
  | Center
  | CenterInsideMap
  | SmoothFollow

type state_t = player_t * env_item_t List.t * Raylib.Camera2D.t * camera_mode_t

val width : int
val height : int
val player_max_speed : float
val player_max_reverse_speed : float
val player_rotation_speed : float
val player_acceleration : float
val game_target_fps : int
val world_street_drag : float
val smooth_min_speed : float
val smooth_min_length : float
val smooth_fraction : float
val bbox_x : float
val bbox_y : float

val half_screen : Raylib.Vector2.t
