scribble_font_set_default("fnt_test_2");

scribble_typewriter_add_character_delay(".", 1000);

typist = scribble_typist();
typist.in(0.2, 0, false);
typist.sound_per_char(snd_crank, 1.0, 1.0); //THIS GETS LOUD