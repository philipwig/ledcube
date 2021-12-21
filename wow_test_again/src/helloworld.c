/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "sleep.h"
#include "stdlib.h"

#define CONTROL_BASE_ADDR 0x43C00000

#define N_ROWS_REGISTER (CONTROL_BASE_ADDR + 4)
#define N_COLS_REGISTER (CONTROL_BASE_ADDR + 8)
#define BITDEPTH_REGISTER (CONTROL_BASE_ADDR + 12)
#define LSB_LENGTH_REGISTER (CONTROL_BASE_ADDR + 16)


#define PATTERN_BASE_ADDR 0x40000000

unsigned int num = 0;


#include "types.h"


void fillPanel(unsigned long long color) {
	for(unsigned int j = 0; j < 64*64*4; j = j + 4) {
	    Xil_Out32(PATTERN_BASE_ADDR + j, color);
	}
}

void matrix_set(int x, int y, RGB color) {
	if (x < 64 && y < 64 && x >= 0 && y >= 0) {
		Xil_Out32(PATTERN_BASE_ADDR + (x + y*64) * 4, (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0));
	}
}

#define FRAMES 255
#define FRAMETIME ((TIME_SHORT * T_SECOND) / 255)


static int pos = 0;
static int frame = 0;

int draw_rainbow() {
	int x;
	int y;
	for (y = 0; y < 64; ++y) {
		for (x = 0; x < 64; ++x) {
			RGB color = HSV2RGB(HSV(pos + x, 255, 255));
			matrix_set(x, y, color);
		}
	}
	if (frame >= FRAMES) {
		frame = 0;
		pos = 0;
		return 1;
	}
	frame++;
	pos++;;
	usleep(25000);
	return 0;
}


uint randn(uint n) {
	if (n == 0)
		return 0; // don't even bother.

	if (n == RAND_MAX)
		return rand();

	n++;

	// Chop off all the values that would cause skew.
	uint end = RAND_MAX / n;
	end *= n;

	// Ignore results that fall in that limit.
	// Worst case, the loop condition should fail 50% of the time.
	uint r;
	while ((r = rand()) >= end);

	return r % n;
}


 #include <math.h>

// --------------------------------------------------------------
#include <stdbool.h>


//#define FIRE_LEVELS 256
#define FIRE_LEVELS 400
#define FIRE_FRAMETIME (50 * T_MILLISECOND)
#define FIRE_FRAMES (TIME_MEDIUM * 20)

static RGB fire_palette_lut[FIRE_LEVELS];
static int *fire;
static int fire_framecount = 0;

void fire_palette_init(void);

int fire_init() {
	fire_palette_init();
	fire = malloc(64 * 64 * sizeof(int));
	return 0;
}

void fire_palette_init(void)
{
	for (int i = 0; i < 32; ++i) {
		/* black to blue */
		fire_palette_lut[i + 0].red = 0;
		fire_palette_lut[i + 0].green = 0;
		fire_palette_lut[i + 0].blue = i << 1;
		fire_palette_lut[i + 0].alpha = 255;

		/* blue to red */
		fire_palette_lut[i + 32].red = i << 3;
		fire_palette_lut[i + 32].green = 0;
		fire_palette_lut[i + 32].blue = 64 - (i << 1);
		fire_palette_lut[i + 32].alpha = 255;

		/* red to yellow */
		fire_palette_lut[i + 64].red = 255;
		fire_palette_lut[i + 64].green = i << 3;
		fire_palette_lut[i + 64].blue = 0;
		fire_palette_lut[i + 64].alpha = 255;

		/* yellow to white */
		fire_palette_lut[i + 96].red = 255;
		fire_palette_lut[i + 96].green = 255;
		fire_palette_lut[i + 96].blue = i << 2;
		fire_palette_lut[i + 96].alpha = 255;

		fire_palette_lut[i + 128].red = 255;
		fire_palette_lut[i + 128].green = 255;
		fire_palette_lut[i + 128].blue = 64 + (i << 2);
		fire_palette_lut[i + 128].alpha = 255;

		fire_palette_lut[i + 160].red = 255;
		fire_palette_lut[i + 160].green = 255;
		fire_palette_lut[i + 160].blue = 128 + (i << 2);
		fire_palette_lut[i + 160].alpha = 255;

		fire_palette_lut[i + 192].red = 255;
		fire_palette_lut[i + 192].green = 255;
		fire_palette_lut[i + 192].blue = 192 + i;
		fire_palette_lut[i + 192].alpha = 255;

		fire_palette_lut[i + 224].red = 255;
		fire_palette_lut[i + 224].green = 255;
		fire_palette_lut[i + 224].blue = 224 + i;
		fire_palette_lut[i + 224].alpha = 255;
	}
}

int fire_draw() {
	int x;
	int y;
	int w = 64;
	int h = 64;
	bool endsoon = fire_framecount >= FIRE_FRAMES;
	bool endnow = endsoon;

	/* Set random hotspots in the bottom line */
	int y_off = w * (h - 1);
	for (x = 0; x < w; x++) {
		/* Get random number when not ending soon. */
		int random = endsoon ? 0 : rand() % 32;
		if (random > 20) { /* set random full heat sparks */
			fire[y_off + x] = 255;
		} else {
			fire[y_off + x] = 0;
		}
	}

#if 0
	if (!endsoon) {
		/* create sparks */
		for (int i = 0; i < 10; i++) {
			int random_x = rand() % w;
			int random_y = (rand() % (h / 4)) + ((h / 4) * 3);
			fire[random_x + (random_y * w)] = 255;
		}
	}
#endif

	/* Advance fire by one frame. */
	int tmp;
	for (int y_off = w * (h - 1); y_off > 0; y_off -= w) {
		for (x = 0; x < w; x++) {
			if (x == 0) { /* leftmost column */
				tmp = fire[y_off];
				tmp += fire[y_off + 1];
				tmp += fire[y_off - w];
				tmp /= 3;
			} else if (x == w - 1) { /* rightmost column */
				tmp = fire[y_off + x];
				tmp += fire[y_off - w + x];
				tmp += fire[y_off + x - 1];
				tmp /= 3;
			} else {
				tmp = fire[y_off + x];
				tmp += fire[y_off + x + 1];
				tmp += fire[y_off + x - 1];
				tmp += fire[y_off - w + x];
				tmp >>= 2;
			}

			/* decay */
			if (tmp > 1) {
				tmp -= 1;
			}

			/* set new pixel value */
			fire[y_off - w + x] = tmp;
		}
	}

	/* Draw fire. */
	for (x = 0; x < w; x++) {
		for (y = 0; y < h; y++) {
			if (fire[x + (y * w)]) {
				endnow = false;
			}
			matrix_set(x, y, fire_palette_lut[fire[x + (y * w)]]);
		}
	}

	if (endnow) {
		fire_framecount = 0;
		return 1;
	}
	fire_framecount++;
	usleep(25000);
	return 0;
}

// -----------------------------------------------------------
#include <math.h>
#include "mathey.h"


static int pos;

static int fire_bufsize;
static byte* fire_buffer[2];
static int mx, my;
static int fx, fy, fo, current_fire;
static RGB fire_palette[256];

static inline int ringmod(int x, int m) {
	return (x % m) + (x<0?m:0);
}
static inline int clamp(int l, int x, int u) {
	return (x<l?l:(x>u?u:x));
}

#define CUR current_fire
#define LAST (current_fire^1)
#define LFXY(_X,_Y) fire_buffer[LAST][ ringmod(_X, mx) + (clamp(0, _Y, mx)*mx) ]
#define CFXY(_X,_Y) fire_buffer[CUR][ ringmod(_X, mx) + (clamp(0, _Y, mx)*mx) ]

static RGB fire_palette_func(byte shade) {
 	double r = 1-cos(((shade/255.0)*M_PI)/2);
 	double g = ((1-cos(((shade/255.0)*6*M_PI)/2))/2) * (r*r*0.5);
 	double b = (1-cos((fmin(shade-128,0)/128.0)*0.5*M_PI)) * r;
 	return RGB(r*255, g*255, b*255);
}

static void fire_addcoal() {
	int i1 = randn(fx);
	int i2 = i1 + randn(fx/6) + (fx/8);
	for( int x = i1; x <= i2; x++ ) {
		CFXY(x, 0) = CFXY(x, 1) = LFXY(x, 0) = LFXY(x, 1) = bmin(CFXY(x,0), 63 + (192 * ( sin(((x-i1)*(M_PI))/(i2-i1)) )));
	}
}

static void fire_cooldown() {
	int d = randn(7) + 3;
	for( int x = 0; x < fx; x++ ) {
		for( int y = 0; y < 2; y++ ) {
			if( LFXY(x,y) > 128 ) {
				CFXY(x,y) = LFXY(x,y) = CFXY(x,y) - d;
			} else {
				CFXY(x,y) = LFXY(x,y) = 128;
			}
		}
	}
	for( int x = 0; x < fx; x++ ) {
		for( int y = 2; y < fy; y++ ) {
			if( CFXY(x,y) > 3 ) {
				CFXY(x, y) -= randn(4);
			} else if( CFXY(x, y) > 0) {
				CFXY(x, y) -= 1;
			}
		}
	}
}

static void fire_generation() {
	fire_addcoal();
	fire_cooldown();
	CUR = LAST;
	for( int x = 0; x < fx; x++ ) {
		for( int y = 1; y < fy-1; y++ ) {
			CFXY(x,y+1) = (LFXY(x,y-1) + LFXY(x,y+1) + LFXY(x-1,y) + LFXY(x+1,y)) / 4;
		}
	}
}

int ghostery_init() {
	mx = 64;
	my = 64;
	fo = 2;
	fx = mx;
	fy = my + fo;
	fire_bufsize = fx*fy;
	fire_buffer[0] = malloc(fire_bufsize);
	fire_buffer[1] = malloc(fire_bufsize);
	for( int i = 0; i <=255; i++ ) {
		fire_palette[i] = fire_palette_func(i);
	}
	return 0;
}

int ghostery_draw() {
	int x;
	int y;
	fire_generation();
	for (y = 0; y < my; ++y) {
		for (x = 0; x < mx; ++x) {
			RGB color = fire_palette[CFXY(x,y+2)];
			matrix_set(x, my-y-1, color);
		}
	}
	if (frame >= FRAMES) {
		frame = 0;
		pos = 0;
		return 1;
	}
	frame++;
	pos++;;
	usleep(25000);
	return 0;
}

// ------------------------------------------------------

int main()
{
    init_platform();

    Xil_Out32(N_ROWS_REGISTER, 64); // Set to 64 for a 64x64 1:32 panel. It will output 2xRGB data for 32 rows
    Xil_Out32(N_COLS_REGISTER, 64);
	Xil_Out32(LSB_LENGTH_REGISTER, 20);
    Xil_Out32(CONTROL_BASE_ADDR, 0x00000003); // Need to set to a hex 3 to enable the led_panel_driver


//    while(1) {
//    	for (int i = 0; i < 64*64*4; i = i + 4) {
//    		Xil_Out32(PATTERN_BASE_ADDR + i, 0xFFFFFFFF);
//
//    		usleep(250);
//    	}
//
//    	for (int i = 0; i <  64*64*4; i = i + 4) {
//    		Xil_Out32(PATTERN_BASE_ADDR + i, 0x000000FF);
//
//    		usleep(250);
//    	}
//
//    	fillPanel(0x00FF0000);
//    	sleep(2);
//
//    	Xil_Out32(PATTERN_BASE_ADDR, 0x00FFFFFF);
//    	for (int i = 0; i < (64*64 - 1)*4; i = i + 4) {
//        	Xil_Out32(PATTERN_BASE_ADDR + i, 0x00000000);
//        	Xil_Out32(PATTERN_BASE_ADDR + i + 4, 0x00FFFFFF);
//
//        	usleep(250 * 100);
//    	}
//    }
    fire_init();
    ghostery_init();
    enum animation {rainbow, fire, ghostery} current_animation = rainbow;

    while (1) {
    	if (current_animation == rainbow) {
    		if(draw_rainbow()) current_animation = fire;
    	}
    	else if (current_animation == fire) {
    		if(fire_draw()) current_animation = fire;

    	}
    	else if (current_animation == ghostery) {
    		if(ghostery_draw()) current_animation = fire;
    	}
    }

    cleanup_platform();
    return 0;
}
