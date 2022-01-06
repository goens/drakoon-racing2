type input_t = {
vector : Raylib.Vector2.t;
restart : bool;
}

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
 let vector = Vector2.create x_val y_val in
 let restart = is_key_down Key.R in
 {vector; restart}
