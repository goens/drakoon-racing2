open Game_data

let player_rec player =
  let open Raylib in
  let x, y, w, h =
    Vector2.(x player.position -. 20., y player.position -. 40., 40., 40.) (* hardcoded sizes *)
  in
  Rectangle.create x y w h


let draw_all (player, env_items, camera, mode) =
  let camera_description = Camera.camera_description in
  let open Raylib in
  begin_drawing ();
  clear_background Color.raywhite;

  begin_mode_2d camera;
  (* Draw environment *)
  List.iter (fun item -> draw_rectangle_rec item.box item.color) env_items;
  (* Draw player *)
  draw_rectangle_rec (player_rec player) Color.red;

  end_mode_2d ();

  draw_text "Controls:" 20 20 10 Color.black;
  draw_text "- Right/Left to move" 40 40 10 Color.darkgray;
  draw_text "- Space to jump" 40 60 10 Color.darkgray;
  draw_text "- Mouse Wheel to Zoom in-out" 40 80 10 Color.darkgray;
  draw_text "- C to change camera mode" 40 100 10 Color.darkgray;
  draw_text "Current camera mode:" 20 120 10 Color.black;
  draw_text (camera_description mode) 20 140 10 Color.darkgray;
  let cur_velocity_str : string = (player.velocity |> Vector2.x |> string_of_float) ^ ", " ^ (player.velocity |> Vector2.y |> string_of_float) in
  draw_text ("Current velocity: " ^ cur_velocity_str) 20 160 10 Color.black;
  let cur_pos_str : string = (player.position |> Vector2.x |> string_of_float) ^ ", " ^ (player.position |> Vector2.y |> string_of_float) in
  draw_text ("Current position: " ^ cur_pos_str) 20 180 10 Color.black;

  end_drawing ();
  (player, env_items, camera, mode)
