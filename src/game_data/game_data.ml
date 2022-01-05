(* Data structures *)

type player_t = { position : Raylib.Vector2.t; velocity : Raylib.Vector2.t; damage : int }

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

(* Constants *)
let width = 800

let height = 450

let player_max_speed = 350.
let player_acceleration = 4.
let smooth_min_speed = 30.0
let smooth_min_length = 10.0
let smooth_fraction = 0.8
let bbox_x, bbox_y = (0.2, 0.2)

let half_screen =
  Raylib.Vector2.create (Float.of_int width /. 2.) (Float.of_int height /. 2.)