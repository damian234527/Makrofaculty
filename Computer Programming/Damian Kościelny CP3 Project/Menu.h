
#pragma once

#include "fstream"
#include "vector"
#include "algorithm"
#include "iterator"
#include "functional"
#include "allegro5/allegro.h"
#include "allegro5/allegro_primitives.h"
#include "allegro5/allegro_font.h"
#include "allegro5/allegro_ttf.h"

#include "Objects.h"

using namespace std;

	extern ALLEGRO_FONT* font;
	extern ALLEGRO_EVENT_QUEUE* event_queue;
	extern ALLEGRO_EVENT event;
	extern ALLEGRO_TIMER* timer;

	//comments in .cpp file

class Menu
{
public:
	Menu();
	void init();
	void set_resolution();
	void display_main_menu();
	void highscore();
	bool select_operation();
};

class Game_area :private Menu
{
public:
	int score=0, previous_direction = 2, direction = 2;
	float fps = 5;
	bool playing = 1, extend = 0;
	Game_area();
	void blank_map();
	void set_hud();
	void get_score();
	bool game_over();
	bool pause();
	void restart_game();
	void play();
};

