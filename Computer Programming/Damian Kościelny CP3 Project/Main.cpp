// CP3 Project Damian Koœcielny.cpp : Defines the entry point for the application.

#include "Menu.h"
#include "Objects.h"

//comments in 'Menu.cpp' and 'Objects.cpp'

int main(int argc, char** argv)
{
	Menu Main;
	Main.set_resolution();
	Main.display_main_menu();
		if (Main.select_operation())
		{
			Game_area L;
			L.play();
			Main.highscore();
		}
	al_destroy_font(font);
	al_destroy_event_queue(event_queue);
	al_destroy_timer(timer);
	al_destroy_display(display);
	
	return 0;
}
