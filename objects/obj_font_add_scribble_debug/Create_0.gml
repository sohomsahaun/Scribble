font_texture_page_size = 512;

global.font_add_font = scribble_font_add("NotoSans", "NotoSans-Regular.ttf", 40, [32, 127], true);
draw_set_font(global.font_add_font);
scribble_font_set_default("NotoSans");

glyph = 74;

alarm_delay = 10;
alarm[0] = alarm_delay;