open Game_data

(*
let player_rec player =
  let open Raylib in
  let x, y, w, h =
 (* hardcoded sizes, should get them from texture *)
    Vector2.(x player.position -. 20., y player.position -. 40., 40., 40.)
  in
  Rectangle.create x y w h
*)

type korando_textures_t = {
 regular : Raylib.Texture.t' Raylib.ctyp;
 smoke : Raylib.Texture.t' Raylib.ctyp;
 fire : Raylib.Texture.t' Raylib.ctyp;
 explosion : Raylib.Texture.t' Raylib.ctyp
}

type graphics_data_t = {
 korando : korando_textures_t
}

let load_graphics state =
 let open Raylib in
 let regular = load_texture "resources/korando.png" in
 let smoke = load_texture "resources/korando_smoke.png" in
 let fire = load_texture "resources/korando_fire.png" in
 let explosion = load_texture "resources/korando_explosion.png" in
 let korando = {regular;smoke;fire;explosion} in
 state,{korando}

let draw_all textures (player, env_items, camera, mode) =
  let camera_description = Camera.camera_description in
  let open Raylib in
  begin_drawing ();
  clear_background Color.raywhite;

  begin_mode_2d camera;
  (* Draw environment *)
  List.iter (fun item -> draw_rectangle_rec item.box item.color) env_items;
  (* Draw player *)
 (*this probably loads it every time, not a good idea*)
  let korando_textures = textures.korando in
  let korando = match player.damage with
    | 0 -> korando_textures.regular
    | 1 -> korando_textures.smoke
    | 2 -> korando_textures.fire
    |_ -> korando_textures.explosion in
  let width, height = float_of_int (Texture.width korando), float_of_int (Texture.height korando) in
  let center = Vector2.add player.position (Vector2.create (-.width /. 2.) (-.height/.2.)) in
  let _, theta = Physics.to_polar_coords player.orientation in
      draw_texture_ex korando center theta 1.0 Color.white;
  (*draw_rectangle_rec (player_rec player) Color.red;*)

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
  let cur_speed_str : string = (player.speed |> string_of_float) in
  draw_text ("Current speed: " ^ cur_speed_str) 20 200 10 Color.black;

  end_drawing ();
  ((player, env_items, camera, mode), textures)
