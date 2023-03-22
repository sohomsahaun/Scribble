#macro __SCRIBBLE_GEN_PAGE_POP  var _page_end_line = _i - 1;\
                                _page_data.__line_end    = _page_end_line;\
                                _page_data.__line_count  = 1 + _page_data.__line_end - _page_data.__line_start;\
                                _page_data.__glyph_end   = _word_grid[# _line_grid[# _page_end_line, __SCRIBBLE_GEN_LINE.__WORD_END], __SCRIBBLE_GEN_WORD.__GLYPH_END];\
                                _page_data.__glyph_count = 1 + _page_data.__glyph_end - _page_data.__glyph_start;\
                                _page_data.__width       = ds_grid_get_max(_line_grid, _page_start_line, __SCRIBBLE_GEN_LINE.__WIDTH, _page_end_line, __SCRIBBLE_GEN_LINE.__WIDTH);\
                                _page_data.__height      = _line_y;\
                                _page_data.__min_y       = (__valign == fa_middle)? -(_line_y div 2) : ((__valign == fa_bottom)? -_line_y :       0);\
                                _page_data.__max_y       = (__valign == fa_middle)?  (_line_y div 2) : ((__valign == fa_bottom)?        0 : _line_y);\
                                ;\// Set up the character indexes for the page, relative to the character index of the first glyph on the page
                                var _page_anim_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];\
                                var _page_anim_end   = _glyph_grid[# _page_data.__glyph_end,   __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];\
                                _page_data.__character_count = 1 + _page_anim_end - _page_anim_start;\
                                ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _page_data.__glyph_end, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, -_page_anim_start);



function __scribble_gen_7_build_pages()
{
    static _generator_state = __scribble_get_generator_state();
    with(_generator_state)
    {
        var _glyph_grid            = __glyph_grid;
        var _word_grid             = __word_grid;
        var _line_grid             = __line_grid;
        var _element               = __element;
        var _model_max_height      = __model_max_height;
        var _line_count            = __line_count;
        var _line_spacing_add      = __line_spacing_add;
        var _line_spacing_multiply = __line_spacing_multiply;
        var _layout_sections       = (_element.__layout_type == __SCRIBBLE_LAYOUT.__SECTION);
    }
    
    var _max_break_height = (_element.__layout_type >= __SCRIBBLE_LAYOUT.__SECTION)? (_model_max_height / __fit_scale) : infinity;
    var _simulated_model_height = _max_break_height;
    var _model_height = 0;
    
    // Set up a new page and set its starting glyph
    // We'll set the ending glyph in the loop below
    var _page_data = __new_page();
    _page_data.__line_start  = 0;
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
    array_push(_page_data.__section_y, 0);
    
    var _page_start_line = 0;
    var _line_y = 0;
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__HEIGHT    ];
        var _break_type  = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__BREAK_TYPE];
        
        if ((_break_type == 0) && ((_line_y + _line_height < _simulated_model_height) || (_page_start_line >= _i)))
        {
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = _line_y;
            if (_line_y + _line_height > _model_height) _model_height = _line_y + _line_height;
            _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;
        }
        else if ((_break_type == 1) || _layout_sections)
        {
            array_push(_page_data.__section_y, _line_y);
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = _line_y;
            if (_line_y + _line_height > _model_height) _model_height = _line_y + _line_height;
            _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;
            
            _simulated_model_height += _max_break_height;
        }
        else
        {
            __SCRIBBLE_GEN_PAGE_POP;
            
            // Create a new page
            _page_data = __new_page();
            _page_data.__line_start  = _i;
            _page_data.__glyph_start = _word_grid[# _line_grid[# _i, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
            array_push(_page_data.__section_y, 0);
            
            _page_start_line = _i;
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = 0;
            if (_line_y + _line_height > _model_height) _model_height = _line_y + _line_height;
            _line_y = _line_spacing_add + _line_height*_line_spacing_multiply;
            
            _simulated_model_height = _max_break_height;
        }
        
        ++_i;
    }
    
    __SCRIBBLE_GEN_PAGE_POP;
    
    __height = _model_height;
}
