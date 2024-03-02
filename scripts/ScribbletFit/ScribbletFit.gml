// Feather disable all

/// Draws plain text without formatting. The text is shrunk down to within the given maximum width
/// and height by reflowing the text at a smaller size. Text will appear immediately using
/// GameMaker's native text rendering. Over a few frames and in the background, Scribble will build
/// a vertex buffer in the background that replaces the native text rendering and is faster to draw.
/// 
/// This function scales text whilst adding newlines. If you want to scale down text without adding
/// newlines, which will gain you a little performance, then use ScribbletShrink().
/// 
/// N.B. Word breaks will only happen on spaces and any single words too long for a line will not
///      be split in the middle. Per-character text wrapping (commonly used for Chinese) is not
///      supported.
/// 
/// This function relies on internal caching for performance gains. If you change any of the
/// following arguments, Scribble will have to do extra work to recache the new text data. Try to
/// limit how often you change these variables to get the best performance.
///     - string
///     - hAlign
///     - vAlign
///     - font
///     - fontScale
///     - maxWidth
///     - maxHeight
/// 
/// @param string
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]
/// @param [width]
/// @param [height]

function ScribbletFit(_string, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity)
{
    static _system = __ScribbletSystem();
    static _cache  = _system.__elementsCache;
    static _array  = _system.__elementsArray;
    
    if ((_string == "") || (_maxWidth < 0) || (_maxHeight < 0)) return;
    if (_font == undefined) _font = _system.__defaultFont;
    var _key = string_concat(_string, ":",
                                _hAlign + 3*_vAlign, ":", //Pack these flags together
                                _font, ":",
                                _fontScale, ":",
                                _maxWidth, ":",
                                _maxHeight, ":B");
    
    var _struct = _cache[$ _key];
    if (_struct == undefined)
    {
        _struct = new __ScribbletClassFit(_key, _string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight);
        _cache[$ _key] = _struct;
        array_push(_array, _struct);
    }
    
    _struct.__lastUse = current_time;
    return _struct;
}