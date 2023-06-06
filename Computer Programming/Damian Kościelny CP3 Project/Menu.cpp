
#include "Menu.h"

ALLEGRO_FONT* font = NULL;
ALLEGRO_EVENT_QUEUE* event_queue = NULL;
ALLEGRO_EVENT event;
ALLEGRO_TIMER* timer = NULL;

Menu::Menu()
//class constructor
{

	al_init();
	al_init_primitives_addon();
	al_init_font_addon();
	al_init_ttf_addon();
	font = al_load_font("arial.ttf", 36, NULL);
}

void Menu::init() 
//initialization and adjustment to fullscreen mode used in constructor
{
	ALLEGRO_MONITOR_INFO aminfo;
	al_get_monitor_info(0, &aminfo);
	desktop_width = aminfo.x2 - aminfo.x1;
	desktop_height = aminfo.y2 - aminfo.y1;
	al_set_new_display_flags(ALLEGRO_FULLSCREEN_WINDOW);
}

void Menu::set_resolution()
//creation of display with screen resolution
{
	ALLEGRO_MONITOR_INFO aminfo;
	al_get_monitor_info(0, &aminfo);
	desktop_width = aminfo.x2 - aminfo.x1 + 1;
	desktop_height = aminfo.y2 - aminfo.y1 + 1;
	al_set_new_display_flags(ALLEGRO_FULLSCREEN_WINDOW);
	display = al_create_display(desktop_width, desktop_height);
}


void Menu::display_main_menu()
//main menu display based on screen resolution
{

	int menu_height;
	menu_height = desktop_height / 5;
	al_clear_to_color(al_map_rgb(0, 0, 0));
	for (int i = 1; i <= 3; i++)
	{
		al_draw_filled_rectangle((desktop_width - 2 * menu_height) / 2, menu_height * i, (desktop_width - (desktop_width - 2 * menu_height) / 2), menu_height * i + menu_height / 3, al_map_rgb(252, 186, 3));
		switch (i)
		{
		case 1:
			al_draw_text(font, al_map_rgb(0, 0, 0), desktop_width / 2, menu_height * i + menu_height / 15, ALLEGRO_ALIGN_CENTER, "PLAY [UP]");
			break;
		case 2:
			al_draw_text(font, al_map_rgb(0, 0, 0), desktop_width / 2, menu_height * i + menu_height / 15, ALLEGRO_ALIGN_CENTER, "HIGH SCORE [DOWN]");
			break;
		case 3:
			al_draw_text(font, al_map_rgb(0, 0, 0), desktop_width / 2, menu_height * i + menu_height / 15, ALLEGRO_ALIGN_CENTER, "EXIT [ESC]");
			break;
		}
	}
	al_flip_display();

}
void Menu::highscore()
//reads higscores from file and dipslays it in the program
{
	int i = 1;
	al_clear_to_color(al_map_rgb(0, 0, 0));
	al_draw_text(font, al_map_rgb(195, 235, 45), desktop_width / 2, desktop_height / 12, ALLEGRO_ALIGN_CENTER, "HIGH SCORES");
	al_draw_filled_rectangle((desktop_width - 2 * desktop_height / 5) / 2, 13 * desktop_height / 15, (desktop_width - (desktop_width - 2 * desktop_height / 5) / 2), 14 * desktop_height / 15, al_map_rgb(252, 186, 3));
	al_draw_text(font, al_map_rgb(0, 0, 0), desktop_width / 2, 53 * desktop_height / 60, ALLEGRO_ALIGN_CENTER, "EXIT [LEFT]");

	//use of exceptions and file streams
	ifstream highscore;
	highscore.exceptions(ifstream::badbit);
	try
	{
		//use of STL templates
		highscore.open("highscore.txt");
		vector<int> x(istream_iterator<int>(highscore), {});
		sort(x.begin(), x.end(), greater<int>());
		for (const auto& score : x)
		{
			al_draw_textf(font, al_map_rgb(195, 235, 45), desktop_width / 2, (3 + i * 1.5) * desktop_height / 24, ALLEGRO_ALIGN_CENTER, "%d.    %d", i, score);
			i++;
			if (i == 11) break;
		}
		highscore.close();
	}
	catch (ifstream::failure higscore_read) {
		al_draw_text(font, al_map_rgb(195, 235, 45), desktop_width / 2, desktop_height / 2, ALLEGRO_ALIGN_CENTER, "CANNOT OPEN highscore.txt");
	}
	al_flip_display();
	while (event.keyboard.keycode != ALLEGRO_KEY_LEFT) al_wait_for_event(event_queue, &event);


}
bool Menu::select_operation()
//allows to select desired action in main menu
{
	int selection = 0;
	al_install_keyboard();
	event_queue = al_create_event_queue();
	al_register_event_source(event_queue, al_get_keyboard_event_source());
	while (1)
	{
		al_wait_for_event(event_queue, &event);
		if (event.keyboard.keycode == ALLEGRO_KEY_UP)
		{
			selection = 1;
			break;
		}
		else if (event.keyboard.keycode == ALLEGRO_KEY_DOWN)
		{
			selection = 2;
			break;
		}
		else if (event.keyboard.keycode == ALLEGRO_KEY_ESCAPE)
		{
			selection = 3;
			break;
		}
	}
	switch (selection)
	{
	case 1: //play game
	{
		return 1;
	}
	case 2: //see highscores
	{
		highscore();
		display_main_menu();
		select_operation();
		break;
	}
	case 3: //exit
		return 0;
	}
}

Game_area::Game_area()
// class constructor
{
	blank_map();
	set_hud();
	Gridcell_size = desktop_height / 15;
}

void Game_area::blank_map()
//creates blank map
{
	al_clear_to_color(al_map_rgb(0, 0, 0));
	al_draw_filled_rectangle((desktop_width - desktop_height) / 2, 0, (desktop_width - (desktop_width - desktop_height) / 2 - 1), desktop_height, al_map_rgb(98, 184, 24));
	al_flip_display();
}
void Game_area::set_hud()
//creates hud
{
	score = 0;
	fps = 5;
	al_draw_text(font, al_map_rgb(195, 235, 45), (desktop_width - (desktop_width - desktop_height) / 2 + (desktop_width - desktop_height) / 4), desktop_height / 15, ALLEGRO_ALIGN_CENTER, "SCORE");
	al_draw_textf(font, al_map_rgb(195, 235, 45), (desktop_width - (desktop_width - desktop_height) / 2 + (desktop_width - desktop_height) / 4), 2 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "%d", score);
	al_draw_text(font, al_map_rgb(195, 235, 45), (desktop_width - desktop_height) / 4, desktop_height / 15, ALLEGRO_ALIGN_CENTER, "SPEED");
	al_draw_textf(font, al_map_rgb(195, 235, 45), (desktop_width - desktop_height) / 4, 2 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "%.1f", fps);

}
void Game_area::get_score()
//changes values displayed on hud
{
	al_draw_filled_rectangle((desktop_width - (desktop_width - desktop_height) / 2), 2 * desktop_height / 15, desktop_width, desktop_height / 6, al_map_rgb(0, 0, 0));
	score += 1;
	al_draw_textf(font, al_map_rgb(195, 235, 45), (desktop_width - (desktop_width - desktop_height) / 2 + (desktop_width - desktop_height) / 4), 2 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "%d", score);
	al_draw_filled_rectangle(0, 2 * desktop_height / 15, (desktop_width - desktop_height) / 2, desktop_height / 6, al_map_rgb(0, 0, 0));
	fps += 0.1;
	al_draw_textf(font, al_map_rgb(195, 235, 45), (desktop_width - desktop_height) / 4, 2 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "%.1f", fps);
}
bool Game_area::game_over()
//allows to restart or exit the game when the snake is dead, also writes current score to the file
{
	al_stop_timer(timer);

	ofstream highscore("highscore.txt", ios_base::app);
	highscore << score << endl;
	highscore.close();


	al_draw_filled_rectangle(desktop_width / 3, desktop_height / 3, 2 * desktop_width / 3, 2 * desktop_height / 3, al_map_rgb(0, 0, 0));
	al_draw_text(font, al_map_rgb(195, 235, 45), desktop_width / 2, 5 * desktop_height / 12, ALLEGRO_ALIGN_CENTER, "GAME OVER");
	al_draw_textf(font, al_map_rgb(195, 235, 45), desktop_width / 2, desktop_height / 2, ALLEGRO_ALIGN_CENTER, "%d", score);
	al_draw_text(font, al_map_rgb(195, 235, 45), desktop_width / 2, 7 * desktop_height / 12, ALLEGRO_ALIGN_CENTER, "RESTART? [y] [n]");
	al_flip_display();
	while (event.keyboard.keycode != ALLEGRO_KEY_Y || event.keyboard.keycode != ALLEGRO_KEY_N)
	{
		al_wait_for_event(event_queue, &event);
		if (event.keyboard.keycode == ALLEGRO_KEY_Y) return 1;
		else if (event.keyboard.keycode == ALLEGRO_KEY_N) return 0;
	}

}
bool Game_area::pause()
//enables to pause the game and unpause it
{
	al_stop_timer(timer);
	al_draw_text(font, al_map_rgb(195, 235, 45), (desktop_width - (desktop_width - desktop_height) / 2 + (desktop_width - desktop_height) / 4), 13 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "PAUSED");
	al_draw_text(font, al_map_rgb(195, 235, 45), (desktop_width - (desktop_width - desktop_height) / 2 + (desktop_width - desktop_height) / 4), 14 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "EXIT GAME? [y] [n]");
	al_draw_text(font, al_map_rgb(195, 235, 45), (desktop_width - desktop_height) / 4, 13 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "PAUSED");
	al_draw_text(font, al_map_rgb(195, 235, 45), (desktop_width - desktop_height) / 4, 14 * desktop_height / 15, ALLEGRO_ALIGN_CENTER, "EXIT GAME? [y] [n]");
	al_flip_display();
	while (event.keyboard.keycode != ALLEGRO_KEY_Y || event.keyboard.keycode != ALLEGRO_KEY_N || event.keyboard.keycode != ALLEGRO_KEY_ESCAPE)
	{
		al_wait_for_event(event_queue, &event);
		if (event.keyboard.keycode == ALLEGRO_KEY_Y) return 1;
		else if (event.keyboard.keycode == ALLEGRO_KEY_N || event.keyboard.keycode == ALLEGRO_KEY_ESCAPE)
		{
			al_draw_filled_rectangle((desktop_width - (desktop_width - desktop_height) / 2), 13 * desktop_height / 15, desktop_width, desktop_height, al_map_rgb(0, 0, 0));
			al_draw_filled_rectangle(0, 13 * desktop_height / 15, (desktop_width - desktop_height) / 2, desktop_height, al_map_rgb(0, 0, 0));
			return 0;
		}
	}
}
void Game_area::restart_game()
//restarts the game from the beginning
{
	previous_direction = 2, direction = 2;
	fps = 5;
	al_set_timer_speed(timer, 1 / fps);
	al_start_timer(timer);
}
void Game_area::play()
//Most important Game_area method that calls the other ones
//It enables the game to be played
{
	Apple A;
	Snake S;
	timer = al_create_timer(1 / fps);
	al_register_event_source(event_queue, al_get_timer_event_source(timer));
	al_start_timer(timer);
	A.create_apple();
	while (playing)
	{

		do
		{
			al_wait_for_event(event_queue, &event);
			if (event.type == ALLEGRO_EVENT_TIMER)
			{
				{
					if (S.snake_move(direction, extend))
					{
						if (game_over())
						{
							al_clear_to_color(al_map_rgb(0, 0, 0));
							blank_map();
							set_hud();
							S.snake_restart();
							A.create_apple();
							restart_game();
						}
						else playing = 0;
					}
					else extend = 0;
					al_flip_display();
				}
			}
			else if ((event.keyboard.keycode == ALLEGRO_KEY_UP || event.keyboard.keycode == ALLEGRO_KEY_W) && previous_direction != 2) direction = 1;
			else if ((event.keyboard.keycode == ALLEGRO_KEY_DOWN || event.keyboard.keycode == ALLEGRO_KEY_S) && previous_direction != 1) direction = 2;
			else if ((event.keyboard.keycode == ALLEGRO_KEY_LEFT || event.keyboard.keycode == ALLEGRO_KEY_A) && previous_direction != 4) direction = 3;
			else if ((event.keyboard.keycode == ALLEGRO_KEY_RIGHT || event.keyboard.keycode == ALLEGRO_KEY_D) && previous_direction != 3) direction = 4;
			else if (event.keyboard.keycode == ALLEGRO_KEY_ESCAPE)
			{
				if (pause()) playing = 0;
				else al_start_timer(timer);
			}
			if (S.x == A.p_x && S.y == A.p_y)
			{
				extend = 1;
				al_set_timer_speed(timer, 1 / fps);
				get_score();
				A.create_apple();
			}
			previous_direction = direction;
		} while (!al_is_event_queue_empty(event_queue));
	}
}