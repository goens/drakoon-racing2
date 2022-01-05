(* Physics *)
open Game_data

(* this currently allows to move to the side, it shouldn't. *)
(* we need to add an orientetation ot the player and just move forward in that orientation *)

let pi = 3.14159_26535_89793_23846_2643

let deg2rad d =
  d *. pi /. 180.0

let rad2deg r =
  (r *. 180.0) /. pi

let calculate_angle_deg v w  =
  let open Raylib.Vector2 in
  let dotprod = dot_product v w in
  let prod = (length v) *. (length w) in
  if prod = 0. then None
  else let theta = acos (dotprod /. prod) in
  Some (rad2deg theta)


let to_polar_coords v =
  let open Raylib.Vector2 in
  let r = length v in
  let theta_raw = if r = 0. then 0.
    else let origin = create 0. (-1.) in
    calculate_angle_deg v origin |> Option.get in
    let theta = if x v > 0. then theta_raw
      else 360. -. theta_raw in
    (r, theta)


let from_polar_coords (r,theta_deg) =
  let theta = deg2rad theta_deg in
  let x = r *. (sin theta) in
  let y = r *. -.(cos theta) in
  Raylib.Vector2.create x y

let update_player_velocity input_vector player =
let open Raylib.Vector2 in

  (*update orientation*)
  (* it should always be a unit vector *)
  let _, theta_old = to_polar_coords player.orientation in
  let theta_new = theta_old +. (player_rotation_speed *. (x input_vector)) in
  let orientation = from_polar_coords (1., theta_new) in

  (*update speed, note that forward is -1. *)
  let speed_change = -.(y input_vector) in
  let speed_drag = if player.speed > 0. then
    max (player.speed -. world_street_drag) 0.
    else min (player.speed +. world_street_drag) 0.
   in
  let speed_updated = speed_drag +. (player_acceleration *. speed_change) in
  let speed = if speed_updated > player_max_speed
    then player_max_speed
    else if speed_updated < (-.player_max_reverse_speed)
    then (-.player_max_reverse_speed)
    else speed_updated in
  Raylib.draw_text (Printf.sprintf "input vector: %f, %f" (x input_vector) (y input_vector)) 20 220 10 Raylib.Color.black;
  Raylib.draw_text (Printf.sprintf "theta old: %f, theta: %f" theta_old theta_new) 20 240 10 Raylib.Color.black;
  {player with speed; orientation}

let update_player_position delta _ player =
let open Raylib.Vector2 in
  let vel : t = scale player.orientation player.speed in
  let pos : t = player.position in
  (* does not account for collisions yet*)
  let position = add pos (scale vel delta) in
  {player with position = position}
