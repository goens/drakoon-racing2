open Game_data

type world_data_t = {
 width : int;
 height : int;
}

type item_size_t = Big | Medium | Small

type random_item_cfg_t = {
  sizes : item_size_t List.t;
  min : int;
  max : int;
}

let ints_of_size = function
 | Big -> (100,100)
 | Medium -> (60,60)
 | Small -> (30,30)

let world_offsets width height =
  let wwidth, wheight = float_of_int width, float_of_int height in
  let x,y = wwidth /. 2., (0.9 *. float_of_int Game_data.window_height -. wheight) in
  (x,y)

let rec gen_rand_item_sizes sizes item_sizes num =
  match num with
  | 0 -> item_sizes
  | _ ->
  let item_size_idx = Raylib.get_random_value 0 (List.length sizes - 1) in
  let new_item = List.nth sizes item_size_idx in
  (gen_rand_item_sizes sizes (new_item::item_sizes) (num - 1))

let rec place_rand_items world_width world_height sizes items =
  match sizes with
   | [] -> items
   | size::rsizes ->
      (* for now, any positions, TODO: ensure some playability*)
      let width, height = ints_of_size size in
      let x_off, y_off = world_offsets world_width world_height in
      let x = (Raylib.get_random_value width (world_width - width) |> float_of_int) +. x_off in
      let y = (Raylib.get_random_value height (world_height - height) |> float_of_int) +. y_off in
      let item = {
          (* y coordinates are negative *)
          box = Raylib.Rectangle.create x y (float_of_int width) (float_of_int height);
          colliding = true;
          color = Raylib.Color.gray;
          } in
      (place_rand_items world_width world_height rsizes (item::items))

let gen_rand_items (world_data : world_data_t) (random_item_cfg : random_item_cfg_t) =
  let num = Raylib.get_random_value random_item_cfg.min random_item_cfg.max  in
  let item_sizes = gen_rand_item_sizes random_item_cfg.sizes [] num in
  let rand_items = place_rand_items world_data.width world_data.height item_sizes [] in
  let wwidth, wheight = float_of_int world_data.width, float_of_int world_data.height in
  let x,y = world_offsets world_data.width world_data.height in

  let world = {
   box = Raylib.Rectangle.create x y (wwidth) (wheight);
   colliding = false;
   color = Raylib.Color.lightgray;
   } in

(*
   let walls = {
   box = Raylib.Rectangle.create x y (wwidth) (wheight);
   colliding = false;
   color = Raylib.Color.lightgray;
   }
 *)
   (world::rand_items)


let init (camera, graphics) =
  let open Raylib in
  let player = { position = half_screen; orientation = Vector2.create 0. (-1.);
                 speed = 0.; damage = 0; invulnerability = 0. } in
  let world_data = {width = Game_data.world_width; height = Game_data.world_height} in
  let random_item_cfg = {
     sizes = [Big;Medium;Medium;Medium;Small;Small];
     min = Game_data.world_min_items;
     max = Game_data.world_max_items;
  } in
  let env_items = gen_rand_items world_data random_item_cfg in
  ((player, env_items, camera, Center), graphics)
