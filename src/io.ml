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
