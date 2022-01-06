open Dr2lib

(* Game functions *)
let setup () =
  let open Raylib in
  let open Game_data in
  set_config_flags [ ConfigFlags.Window_resizable ];
  init_window width height "Drakoon Racing 2";
  let camera = Camera2D.create half_screen (Vector2.create 0. 0.) 0.0 1.0 in
  set_target_fps game_target_fps;
  camera


let rec loop (state, graphics) =
  let delta = Raylib.get_frame_time () in
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
      state |> Gameplay.update_state delta graphics |> Camera.update_camera delta |> Graphics.draw_all graphics |> loop

let () = setup () |> Graphics.load_graphics |> World.init |> loop
