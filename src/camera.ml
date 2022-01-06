open Game_data

let camera_description = function
  | Center -> "Follow player center"
  | CenterInsideMap -> "Follow player center, but clamp to map edges"
  | SmoothFollow -> "Follow player center; smoothed"

let clamp_zoom z = if z > 3.0 then 3.0 else if z < 0.25 then 0.25 else z

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
              (shift_cam x (Float.of_int window_width))
              (shift_cam y (Float.of_int window_height)))
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

