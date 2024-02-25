if (mouse_check_button(mb_left))
{
    width  = mouse_x - x;
    height = mouse_y - y;
}

if (keyboard_check_pressed(vk_left)) width--;
if (keyboard_check_pressed(vk_right)) width++;

if (keyboard_check_pressed(ord("1"))) mode = 1;
if (keyboard_check_pressed(ord("2"))) mode = 2;
if (keyboard_check_pressed(ord("3"))) mode = 3;
if (keyboard_check_pressed(ord("4"))) mode = 4;

initialTimer++;
if (initialTimer > 120)
{
    if (fps >= 60)
    {
        if (fps_real >= 70)
        {
            stressCount++;
        }
        else
        {
            stressCount += 0.25;
        }
    }
    else if (fps < 60)
    {
        if (fps < 30)
        {
            stressCount -= 5;
        }
        else
        if (fps < 50)
        {
            stressCount--;
        }
        else
        {
            stressCount -= 0.25;
        }
    }
}