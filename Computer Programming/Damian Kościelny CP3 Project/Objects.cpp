
#include "Objects.h"

int Gridcell_size;  //size of one cell that can be occupied by snake segment or an apple
int desktop_height;
int desktop_width;
ALLEGRO_DISPLAY* display = NULL;

	Snake::Snake()
	//constructor
	{
		snake_restart();
	};

	void Snake::snake_restart()
	//allows to set initial position and length of snake
	{
		size = 3;
		x = desktop_width / 2;
		y = 7 * Gridcell_size / 2;
		segment_size = Gridcell_size;
		segment_pos.resize(size * 2);
		for (int i = 0; i < size; i++)
		{
			segment_pos[2 * i] = x;
			segment_pos[(2 * i) + 1] = y - i * segment_size;
			al_draw_filled_rectangle(segment_pos[2 * i] - segment_size / 2, segment_pos[2 * i + 1] - segment_size / 2, segment_pos[2 * i] + segment_size / 2, segment_pos[2 * i + 1] + segment_size / 2, al_map_rgb(10, 10, 250));
		}
		al_flip_display();
	}

	bool Snake::snake_move(int direction, bool extend)
	//method that is responsible for proper snake movement
	{
		switch (direction)
		{
		case 1:
		{
			if (segment_pos[3] + segment_size == y) break;  //checks if space is occupied by snake
			y -= segment_size;
			snake_redraw(extend);
			break;
		}
		case 2:
		{
			if (segment_pos[3] - segment_size == y) break;
			y += segment_size;
			snake_redraw(extend);
			break;
		}
		case 3:
		{
			if (segment_pos[2] + segment_size == x) break;
			x -= segment_size;
			snake_redraw(extend);
			break;
		}
		case 4:
		{
			if (segment_pos[2] - segment_size == x) break;
			x += segment_size;
			snake_redraw(extend);
			break;
		}
		}
		if (snake_collision())
		{
			al_draw_filled_rectangle(segment_pos[0] - segment_size / 2, segment_pos[1] - segment_size / 2, segment_pos[0] + segment_size / 2, segment_pos[1] + segment_size / 2, al_map_rgb(255, 10, 10));
			return 1;
		}
		else
		{
			return 0;
		}
	}
	void Snake::snake_redraw(bool extend)
	//redraws snake when moving
	{
		segment_pos.emplace_front(y);
		segment_pos.emplace_front(x);
		int back = segment_pos.size() - 1;
		if (extend == 0)
		{
			al_draw_filled_rectangle(segment_pos[back - 1] - segment_size / 2, segment_pos[back] - segment_size / 2, segment_pos[back - 1] + segment_size / 2, segment_pos[back] + segment_size / 2, al_map_rgb(98, 184, 24));
			segment_pos.erase(segment_pos.end() - 2, segment_pos.end());
		}
		al_draw_filled_rectangle(segment_pos[0] - segment_size / 2, segment_pos[1] - segment_size / 2, segment_pos[0] + segment_size / 2, segment_pos[1] + segment_size / 2, al_map_rgb(10, 10, 250));
	}
	void Snake::snake_draw()
	//draws snake
	{

		for (int i = 0; i < segment_pos.size() / 2; i++)
		{
			al_draw_filled_rectangle(segment_pos[2 * i] - segment_size / 2, segment_pos[2 * i + 1] - segment_size / 2, segment_pos[2 * i] + segment_size / 2, segment_pos[2 * i + 1] + segment_size / 2, al_map_rgb(10, 10, 250));
		}

	}
	bool Snake::snake_collision()
	//detects collision of snake with wall or with itself
	{
		for (int i = 1; i < segment_pos.size() / 2; i++)
		{
			if ((x == segment_pos[2 * i] && y == segment_pos[2 * i + 1]) || x<(desktop_width - desktop_height) / 2 || x>desktop_width - ((desktop_width - desktop_height) / 2) || y<0 || y>desktop_height) return 1;
		}
		return 0;
	}



	Apple::Apple()
		//constructor
		{
		p_x = x;
		p_y = y;
			size = Gridcell_size / 4;
			apple_col = al_map_rgb(255, 10, 10);
			srand(time(NULL));
		}
		void Apple::create_apple()
		//spawns apple in random gridcell on map, also checks if the place is occupied
		{
			ALLEGRO_COLOR color;
			ALLEGRO_BITMAP* bitmap;
			unsigned char r, g, b;
			do
			{
				p_x = ((rand() % 14) * Gridcell_size + ((desktop_width - desktop_height + Gridcell_size) / 2));
				p_y = (rand() % 14 * Gridcell_size + Gridcell_size / 2);
				bitmap = al_get_backbuffer(display);
				color = al_get_pixel(bitmap, p_x, p_y);
				al_unmap_rgb(color, &r, &g, &b);
			} while (r == 10 && g == 10 && b == 250);  // do not spawn apple if place is occupied by snake
			draw_apple(p_x, p_y);
		}
		void Apple::draw_apple(int x, int y)
		//draws an apple
		{
			al_draw_filled_circle(x, y, size, apple_col);
		}
	