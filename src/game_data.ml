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

(* Constants *)
let window_width = 800
let window_height = 450

let player_max_speed = 300.
let player_max_reverse_speed = 150.
let player_max_damage = 3
let player_rotation_speed = 1.0
let player_acceleration = 6.
let player_invulnerability_time = 3.

let world_street_drag = 1.5
let world_min_items = 20
let world_max_items = 40
let world_width = 500
let world_height = 5000

let game_target_fps = 60

let smooth_min_speed = 130.0
let smooth_min_length = 10.0
let smooth_fraction = 2.8
let bbox_x, bbox_y = (0.2, 0.2)

let half_screen =
  Raylib.Vector2.create (Float.of_int window_width /. 2.) (Float.of_int window_height /. 2.)
