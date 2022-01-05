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

let half_screen =
  Raylib.Vector2.create (Float.of_int width /. 2.) (Float.of_int height /. 2.)

let player_max_speed = 350.
let player_acceleration = 4.
let smooth_min_speed = 30.0
let smooth_min_length = 10.0
let smooth_fraction = 0.8
let bbox_x, bbox_y = (0.2, 0.2)

(* I/O *)

let read_input () =
 let open Raylib in
 let x_val =
    match (is_key_down Key.Left, is_key_down Key.Right) with
    | true, false -> -1.
    | false, true -> 1.
    | _, _ -> 0.
 in
 let y_val =
    match (is_key_down Key.Up, is_key_down Key.Down) with
    | true, false -> -1.
    | false, true -> 1.
    | _, _ -> 0.
 in
 Vector2.create x_val y_val

(* Physics *)

let update_player_velocity input_vector player =
let open Raylib.Vector2 in
  let vel : t = player.velocity in
  let vel_new = add vel (scale input_vector player_acceleration) in
  let speed = length vel_new in
  let factor = if speed <= player_max_speed
     then 1.
     else player_max_speed /. speed in
  {player with velocity = scale vel_new factor}

let update_player_position delta _ player =
let open Raylib.Vector2 in
  let vel : t = player.velocity in
  let pos : t = player.position in
  (* does not account for collisions yet*)
  let position = add pos (scale vel delta) in
  {player with position = position}

(* Camera *)

type comparision_t = Higher | Lower | Equal

let compare tol a b =
  if Float.abs (a -. b) < tol then Equal else if a > b then Higher else Lower

let player_rec player =
  let open Raylib in
  let x, y, w, h =
    Vector2.(x player.position -. 20., y player.position -. 40., 40., 40.) (* hardcoded sizes *)
  in
  Rectangle.create x y w h

let camera_description = function
  | Center -> "Follow player center"
  | CenterInsideMap -> "Follow player center, but clamp to map edges"
  | SmoothFollow -> "Follow player center; smoothed"

let clamp_zoom z = if z > 3.0 then 3.0 else if z < 0.25 then 0.25 else z

let vy_of_float y = Raylib.Vector2.create 0.0 y

(* Game functions *)
let setup () =
  let open Raylib in
  set_config_flags [ ConfigFlags.Window_resizable ];
  init_window width height "raylib [core] example - 2d camera";
  let player = { position = half_screen; velocity = Vector2.create 0. 0.; damage = 0 } in
  let env_items =
    [
      {
        box = Rectangle.create 0.0 0.0 1000.0 500.0;
        blocking = false;
        color = Color.lightgray;
      };
      {
        box = Rectangle.create 0.0 400.0 1000.0 200.0;
        blocking = true;
        color = Color.gray;
      };
      {
        box = Rectangle.create 300.0 200.0 400.0 10.0;
        blocking = true;
        color = Color.gray;
      };
      {
        box = Rectangle.create 250.0 300.0 100.0 10.0;
        blocking = true;
        color = Color.gray;
      };
      {
        box = Rectangle.create 650.0 300.0 100.0 10.0;
        blocking = true;
        color = Color.gray;
      };
    ]
  in
  let camera = Camera2D.create half_screen player.position 0.0 1.0 in
  set_target_fps 60;
  (player, env_items, camera, Center)





let update_player delta (player, env_items, c, m) =
  let input_vector = read_input () in
  let player = player |> update_player_velocity input_vector |> update_player_position delta env_items
  in (player, env_items, c, m)

let update_camera delta (player, env_items, camera, mode) =
  let open Raylib in
  let mode =
    if is_key_pressed Key.C then
      match mode with
      | Center -> CenterInsideMap
      | CenterInsideMap -> SmoothFollow
      | SmoothFollow -> Center
    else mode
  in
  let offset, target, mode =
    match mode with
    | Center -> (half_screen, player.position, mode)
    | CenterInsideMap ->
        let camera =
          (* I am not too happy about this trick *)
          Camera2D.(
            create half_screen player.position (rotation camera) (zoom camera))
        in
        let shift =
          let minX, minY, maxX, maxY =
            List.fold_right
              (fun elem (minX, minY, maxX, maxY) ->
                let x, y, w, h =
                  ( Rectangle.x elem.box,
                    Rectangle.y elem.box,
                    Rectangle.width elem.box,
                    Rectangle.height elem.box )
                in
                ( Float.min minX x,
                  Float.min minY y,
                  Float.max maxX (x +. w),
                  Float.max maxY (y +. h) ))
              env_items
              (1000.0, 1000.0, ~-.1000.0, ~-.1000.0)
          in
          let vmin = get_world_to_screen_2d (Vector2.create minX minY) camera in
          let vmax = get_world_to_screen_2d (Vector2.create maxX maxY) camera in
          let shift_cam get_coord maxi =
            let low, high = (get_coord vmin, get_coord vmax) in
            if low > 0.0 then ~-.low
            else if high < maxi then maxi -. high
            else 0.0
          in
          Vector2.(
            create
              (shift_cam x (Float.of_int width))
              (shift_cam y (Float.of_int height)))
        in
        let offset = Vector2.add half_screen shift in
        (offset, player.position, mode)
    | SmoothFollow ->
        let target =
          let diff =
            Vector2.subtract player.position (Camera2D.target camera)
          in
          let length = Vector2.length diff in
          if length < smooth_min_length then Camera2D.target camera
          else
            Vector2.add (Camera2D.target camera)
              (Vector2.scale diff
                 (delta
                 *. Float.max smooth_fraction (smooth_min_speed /. length)))
        in
        (half_screen, target, mode)
  in
  let zoom =
    if is_key_pressed Key.R then 1.0
    else clamp_zoom (Camera2D.zoom camera +. (0.05 *. get_mouse_wheel_move ()))
  in
  ( player,
    env_items,
    Camera2D.create offset target (Camera2D.rotation camera) zoom,
    mode )

let draw_all (player, env_items, camera, mode) =
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

let rec loop state =
  let delta = Raylib.get_frame_time () in
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
      state |> update_player delta |> update_camera delta |> draw_all |> loop

let () = setup () |> loop
