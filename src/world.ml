open Game_data

let init (camera, graphics) =
  let open Raylib in
  let player = { position = half_screen; orientation = Vector2.create 0. (-1.);
                 speed = 0.; damage = 0; invulnerability = 0. } in
  let env_items =
    [
      {
        box = Rectangle.create 200. (-.1600.0) 500.0 2000.0;
        colliding = false;
        color = Color.lightgray;
      };
      {
        box = Rectangle.create 400.0 (-1200.0) 40.0 40.0;
        colliding = true;
        color = Color.gray;
      };
      {
        box = Rectangle.create 400.0 (120.0) 40.0 40.0;
        colliding = true;
        color = Color.gray;
      };
      {
        box = Rectangle.create 500.0 (-800.0) 40.0 40.0;
        colliding = true;
        color = Color.gray;
      };
    ]
  in
  ((player, env_items, camera, Center), graphics)
