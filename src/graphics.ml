open Game_data

let deg2rad d =
  let pi = 3.14159_26535_89793_23846_2643 in
  d *. pi /. 180.0

(*let player_rec player =
  let open Raylib in
  let x, y, w, h =
 (* hardcoded sizes, should get them from texture *)
    Vector2.(x player.position -. 20., y player.position -. 40., 40., 40.)
  in
  Rectangle.create x y w h
*)
let draw_all (player, env_items, camera, mode) =
  let camera_description = Camera.camera_description in
  let open Raylib in
  begin_drawing ();
  clear_background Color.raywhite;

  begin_mode_2d camera;
  (* Draw environment *)
  List.iter (fun item -> draw_rectangle_rec item.box item.color) env_items;
  (* Draw player *)
 (*this probably loads it every time, not a good idea*)
  let korando = load_texture "resources/korando.png" in
  let theta = if (Vector2.x player.orientation) != 0. then
     ((Vector2.x player.orientation) /. (Vector2.y player.orientation)) |> deg2rad |> atan
     else 0. in
      draw_texture_ex korando player.position theta 1.0 Color.white;


  end_mode_2d ();

  draw_text "Controls:" 20 20 10 Color.black;
  draw_text "- Right/Left to move" 40 40 10 Color.darkgray;
  draw_text "- Space to jump" 40 60 10 Color.darkgray;
  draw_text "- Mouse Wheel to Zoom in-out" 40 80 10 Color.darkgray;
  draw_text "- C to change camera mode" 40 100 10 Color.darkgray;
  draw_text "Current camera mode:" 20 120 10 Color.black;
  draw_text (camera_description mode) 20 140 10 Color.darkgray;
  let cur_orientation_str : string = (player.orientation |> Vector2.x |> string_of_float) ^ ", " ^ (player.orientation |> Vector2.y |> string_of_float) in
  draw_text ("Current orientation: " ^ cur_orientation_str) 20 160 10 Color.black;
  let cur_pos_str : string = (player.position |> Vector2.x |> string_of_float) ^ ", " ^ (player.position |> Vector2.y |> string_of_float) in
  draw_text ("Current position: " ^ cur_pos_str) 20 180 10 Color.black;

  end_drawing ();
  (player, env_items, camera, mode)
