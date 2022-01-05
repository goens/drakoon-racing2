open Game_data

type korando_textures_t = {
 regular : Raylib.Texture.t;
 smoke : Raylib.Texture.t;
 fire : Raylib.Texture.t;
 explosion : Raylib.Texture.t
}

type graphics_data_t = {
 korando : korando_textures_t
}

val draw_all : graphics_data_t -> state_t -> state_t * graphics_data_t
val load_graphics : state_t -> state_t * graphics_data_t

