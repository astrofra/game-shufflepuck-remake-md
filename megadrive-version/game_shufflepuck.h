#include <genesis.h>

#ifndef SHUFFLE_GAME
#define SHUFFLE_GAME

/*	The whole game logic, physics and timings are based
	on the frequency of the video system.
	- If you need to build a PAL version, 
	  simply change the value above from 60 to 50.
	- If you want to build a super slow version,
	  simply change the value above to 300...
*/
#define VIDEO_FREQ	60

/*	The board, rackets and puck are simulated in 2D.
	The board size is defined below.
*/
#define board_scale 2
#define shuffle_speed_scale 3
#define board_width FIX32(16.5 * board_scale)
#define board_length FIX32(64.5 * board_scale)

#define SFL_GAME_PRELAUNCH 0
#define SFL_GAME_LAUNCH 1
#define SFL_GAME_PLAY 2
#define SFL_GAME_GOAL 3
#define SFL_GAME_POSTGOAL 4
#define SFL_GAME_SCORE_UPD 5

/*
	Racket game object
*/
typedef struct {
	fix32	max_racket_speed;
	fix32	racket_speed;

	fix32	velocity_x,
			velocity_z;

	fix32	initial_pox_x,
			initial_pox_z;

	fix32	pos_x,
			pos_z;

	fix32	target_pos_x,
			target_pos_z;

	fix32	prev_pos_x,
			prev_pos_z;

	fix32	width,
			length;
}shuffle_racket;

/*	
	Ball game object
*/
struct {
	fix32	inertia;

	fix32	velocity_x,
			velocity_z;

	fix32	initial_pox_x,
			initial_pox_z;

	fix32	pos_x,
			pos_z;

	fix32	prev_pos_x,
			prev_pos_z;

	fix32 	radius;
}ball;

#endif