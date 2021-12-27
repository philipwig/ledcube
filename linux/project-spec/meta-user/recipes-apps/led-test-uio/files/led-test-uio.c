/*****************************************************************************/
/*                               H E A D E R                                 */
/*****************************************************************************/

// Program Name          : LED_DimmerUIO.c
// Program Type          : Linux C application program for Zynq
// Platform              : Zynq All Programmable SoC
// Board                 : ZedBoard
// Description           : Use userspace IO (UIO) device driver to control GPIO
// Date                  : 2014-05-02


/*****************************************************************************/
/*                         I N C L U D E   F I L E S                         */
/*****************************************************************************/
// Base includes
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

// Animation includes
#include "include/types.h"
#include <math.h>
#include <stdbool.h>
#include "include/mathey.h"


/*****************************************************************************/
/*                            D E F I N E S                                  */
/*****************************************************************************/


#define GPIO_MAP_SIZE 		0x10000
#define GPIO_DATA_OFFSET 	0x00
#define GPIO_TRI_OFFSET 	0x04
#define GPIO2_DATA_OFFSET 	0x00
#define GPIO2_TRI_OFFSET 	0x04

#define CONTROL_BASE_ADDR 0x43C00000

#define CONTROL_OFFSET 0
#define N_ROWS_OFFSET 4
#define N_COLS_OFFSET 8
#define BITDEPTH_OFFSET 12
#define LSB_LENGTH_OFFSET 16


void *control_base_addr;
void *data_base_addr;

/*****************************************************************************/
/*                                OTHER FUNCS                                    */
/*****************************************************************************/

void fillPanel(unsigned long long color) {
	for(unsigned int j = 0; j < 64*64*4; j = j + 4) {
	    *((unsigned *)(data_base_addr + j)) = color; // Need to set to a hex 3 to enable the led_panel_driver
	}
}

void matrix_set(int x, int y, RGB color) {
	if (x < 64 && y < 64 && x >= 0 && y >= 0) {
	    *((unsigned *)(data_base_addr + (x + y*64) * 4)) = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
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


// ******************************* FIRE *****************************************

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

// *******************************************************************************



/*****************************************************************************/
/*                                M A I N                                    */
/*****************************************************************************/


int main(void)
{
	int 		value 		= 0;
	int 		period 		= 0;
	int 		brightness 	= 0;
	int 		fd;

	

	fprintf(stderr,"Opening /dev/uio1\n");
	fd = open("/dev/uio1", O_RDWR);
	if (fd < 1) {
		fprintf(stderr,"Invalid UIO device file.\n");
		return -1;
	}
	control_base_addr = mmap(NULL, GPIO_MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);


	fprintf(stderr,"Opening /dev/uio0\n");
	fd = open("/dev/uio0", O_RDWR);
	if (fd < 1) {
		fprintf(stderr,"Invalid UIO device file.\n");
		return -1;
	}
	// mmap the UIO device
	data_base_addr = mmap(NULL, GPIO_MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

	
	// Clear LED
	fprintf(stdout,"\nInitilize Panel\n");
	// *((unsigned *)(ptr + GPIO_TRI_OFFSET)) = 0;
	*((unsigned *)(control_base_addr + CONTROL_OFFSET)) = 0; // Clear control register
	*((unsigned *)(control_base_addr + N_ROWS_OFFSET)) = 64; // Set to 64 for a 64x64 1:32 panel. It will output 2xRGB data for 32 rows
	*((unsigned *)(control_base_addr + N_COLS_OFFSET)) = 64;
	*((unsigned *)(control_base_addr + LSB_LENGTH_OFFSET)) = 20;
	
	fire_init();
    enum animation {rainbow, fire} current_animation = rainbow;

	while (1) {
		fprintf(stdout,"\nInput 1 to enable driver, 0 to disable it, 3 for animations: ");
		scanf("%d", &value);

        if (value == 0) {
            fprintf(stdout,"Disabling driver\n", period);
	        *((unsigned *)(control_base_addr + CONTROL_OFFSET)) = 0; // Need to set to a hex 3 to enable the led_panel_driver
        }
        else if (value == 1) {
            fprintf(stdout,"Enabling driver\n", period);
	        *((unsigned *)(control_base_addr + CONTROL_OFFSET)) = 0x00000003; // Need to set to a hex 3 to enable the led_panel_driver
        }
		else if (value == 3) {
			while (1) {
				if (current_animation == rainbow) {
					if(draw_rainbow()) current_animation = fire;
				}
				else if (current_animation == fire) {
					if(fire_draw()) current_animation = rainbow;
				}
			}
		}
        else {
            fprintf(stdout,"Writing to data\n", period);
			for (int i = 0; i < GPIO_MAP_SIZE; i = i + 4) {
	        	*((unsigned *)(data_base_addr + i)) = value; // Need to set to a hex 3 to enable the led_panel_driver
			}
        }
	}

	// Unmap the address range		
	munmap(data_base_addr, GPIO_MAP_SIZE);
	munmap(control_base_addr, GPIO_MAP_SIZE);
	return 0;
	
}
