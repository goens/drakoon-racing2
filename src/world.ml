open Game_data

let setup () =
  let open Raylib in
  set_config_flags [ ConfigFlags.Window_resizable ];
  init_window width height "raylib [core] example - 2d camera";
  let player = { position = half_screen; orientation = Vector2.create 0. (-1.); speed = 0.; damage = 0 } in
  let env_items =
    [
      (* { *)
      (*   box = Rectangle.create 0.0 0.0 800.0 2500.0; *)
      (*   blocking = false; *)
      (*   color = Color.lightgray; *)
      (* }; *)
      {
        box = Rectangle.create 150. (-.1600.0) 500.0 2000.0;
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
  set_target_fps game_target_fps;
  (player, env_items, camera, Center)
