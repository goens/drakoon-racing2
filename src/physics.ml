(* Physics *)
open Game_data

(* this currently allows to move to the side, it shouldn't. *)
(* we need to add an orientetation ot the player and just move forward in that orientation *)
let update_player_velocity input_vector player =
let open Raylib.Vector2 in

  (*update orientation*)
  let orientation_old : t = player.orientation in
  let updated_orientation  = add orientation_old (scale input_vector player_rotation_speed) in
  let orientation = normalize updated_orientation in

  (*update speed*)
  let speed_change = y input_vector in
  let speed_updated = player.speed +. (player_acceleration *. speed_change) in
  let speed = if speed_updated > player_max_speed
    then player_max_speed
    else if speed_updated < player_max_reverse_speed
    then player_max_reverse_speed
    else speed_updated in
  {player with speed; orientation}

let update_player_position delta _ player =
let open Raylib.Vector2 in
  let vel : t = scale player.orientation player.speed in
  let pos : t = player.position in
  (* does not account for collisions yet*)
  let position = add pos (scale vel delta) in
  {player with position = position}
