open Dr2lib

(* Game functions *)
let rec loop (state, graphics) =
  let delta = Raylib.get_frame_time () in
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
      state |> Gameplay.update_player delta |> Camera.update_camera delta |> Graphics.draw_all graphics |> loop

let () = World.setup () |> Graphics.load_graphics |> loop
