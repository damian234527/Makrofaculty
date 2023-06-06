#pragma once

#include "deque"
#include "stdlib.h"
#include "time.h"

#include "Menu.h"

using namespace std;

extern int Gridcell_size;
extern int desktop_height;
extern int desktop_width;
extern ALLEGRO_DISPLAY* display;

//comments in .cpp file

class Object
{
public:
	int size, x, y;
};

class Snake: public Object
{
public:
	deque<int> segment_pos;
	int segment_size;

	Snake();
	void snake_restart();
	bool snake_move(int direction, bool extend);
	void snake_redraw(bool extend);
	void snake_draw();
	bool snake_collision();
};

class Apple : public Object
{
public:
	int p_x, p_y;
	ALLEGRO_COLOR apple_col;
	Apple();
	void create_apple();
	void draw_apple(int x, int y);
};
