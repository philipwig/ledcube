// Dummy output.
//
// Copyright (c) 2019, Adrian "vifino" Pistol <vifino@tty.sh>
// 
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
// 
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#include <types.h>
#include <timers.h>
#include <assert.h>



#define MATRIX_X 64
#define MATRIX_Y 64

// Matrix size
#ifndef MATRIX_X
#error Define MATRIX_X as the matrixes X size.
#endif

#ifndef MATRIX_Y
#error Define MATRIX_Y as the matrixes Y size.
#endif




#include <stdio.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>


#include <getopt.h>
#include <stdlib.h>
#include "../include/system.h"
#include "../include/uio_helper.h"
#include <string.h>

#include <signal.h>

#include <poll.h>
#include <time.h>
#include <sys/time.h>


#define CONTROL_OFFSET 0
#define N_ROWS_OFFSET 4
#define N_COLS_OFFSET 8
#define BITDEPTH_OFFSET 12
#define LSB_LENGTH_OFFSET 16
#define BRIGHTNESS_OFFSET 20
#define BUFFER_OFFSET 24


int uio_filter;
int fd_ctrl, fd_data;

int32_t *ctrl_base_addr;
int32_t *data_base_addr;





static int pos = 0;
static int frame = 0;

int draw_x_line() {
	static int x;
	static int y;

	static int32_t buffer[64*64];

	for (y = 0; y < 64; ++y) {
		for (x = 0; x < 64; ++x) {
			if (x == pos) {
				buffer[x+y*64] = 0xFFFFFFFF; // Need to set to a hex 3 to enable the led_panel_driver
			}
			else {
				buffer[x+y*64] = 0; // Need to set to a hex 3 to enable the led_panel_driver
			}
		}
	}

	memcpy(data_base_addr, buffer, sizeof(buffer));
	// memcpy(buffer2, buffer, sizeof(buffer));

	if (pos > 64) {
		pos = 0;
	}
	else {
		pos++;

	}
	// usleep(25000);
	return 0;
}

#define FRAMES 255
#define FRAMETIME ((TIME_SHORT * T_SECOND) / 255)

int draw_rainbow() {
	int x;
	int y;

	static int32_t buffer[64*64];
	static int32_t buffer2[64*64];

	for (y = 0; y < 64; ++y) {
		for (x = 0; x < 64; ++x) {
			RGB color = HSV2RGB(HSV(pos + x, 255, 255));
			// matrix_set(x, y, color);
			// buffer[x+y*64] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
			data_base_addr[x+y*64] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
		}
	}

	// memcpy(data_base_addr, buffer, sizeof(buffer));
	// memcpy(buffer2, buffer, sizeof(buffer));


	if (frame >= FRAMES) {
		frame = 0;
		pos = 0;
		return 1;
	}
	frame++;



	pos++;;
	// usleep(25000);
	return 0;
}




void init_panel() {
	struct uio_info_t *info_list, *p;

	uio_filter = -1;

	info_list = uio_find_devices(uio_filter);
	if (!info_list)
		printf("No UIO devices found.\n");

	p = info_list;


	struct uio_info_t *uio_ctrl, *uio_data;

	while (p) {
		uio_get_all_info(p);

		printf("Name: %s\n", p->name);

		if (strcmp((char *) p->name, "led_driver_ctrl") == 0) {
			uio_ctrl = p;
			printf("Found ctrl uio\n");
		}
		else if (strcmp((char *) p->name, "led_driver_data") == 0) {
			uio_data = p;
			printf("Found data uio\n");
		}

		p = p->next;
	}

	// int fd;
	char dev_name[16];



	// ************** Map Ctrl ************
	fd_ctrl = open("/dev/uio0",O_RDWR);
	if (fd_ctrl < 0)
		printf("ERROR: Unable to open ctrl uio");
	else {
		ctrl_base_addr = mmap( NULL,
					uio_ctrl->maps[0].size,
					PROT_READ|PROT_WRITE,
					MAP_SHARED,
					fd_ctrl,
					0*getpagesize());

		close(fd_ctrl);
		printf("Opened ctrl uio\n");
	}

	// **********************************



	// ************** Map data ************
	fd_data = open("/dev/uio1",O_RDWR);
	if (fd_data < 0)
		printf("ERROR: Unable to open data uio");
	else {
		data_base_addr = mmap( NULL,
			       uio_data->maps[0].size,
					PROT_READ|PROT_WRITE,
			       MAP_SHARED,
			       fd_data,
			       0*getpagesize());
		close(fd_data);	
		printf("Opened data uio\n");
	}
	// **********************************


	// ************** Initialize panel ************
	fprintf(stdout,"\nInitialize Panel\n");
	ctrl_base_addr[0] = 2;  // ctrl_display
	ctrl_base_addr[1] = 64; // ctrl_n_rows
	ctrl_base_addr[2] = 64; // ctrl_n_cols
	ctrl_base_addr[3] = 8;  // ctrl_bitdepth
	ctrl_base_addr[4] = 14; // ctrl_lsb_blank
	// ctrl_base_addr[4] = 50; // ctrl_lsb_blank
	ctrl_base_addr[5] = 0;  // ctrl_brightness
	ctrl_base_addr[6] = 0;  // ctrl_buffer

	ctrl_base_addr[0] = 1;

                // 3'b000: axil_read_data <= ctrl_display;
                // 3'b001: axil_read_data <= ctrl_n_rows;
                // 3'b010: axil_read_data <= ctrl_n_cols;
                // 3'b011: axil_read_data <= ctrl_bitdepth;
                // 3'b100: axil_read_data <= ctrl_lsb_blank;
                // 3'b101: axil_read_data <= ctrl_brightness;
                // 3'b110: axil_read_data <= ctrl_buffer;
	// **********************************
}






static int32_t buffer[64*64];


int init(void) {

	init_panel();
	return 0;
}

int getx(int _modno) {
	return MATRIX_X;
}
int gety(int _modno) {
	return MATRIX_Y;
}

int set(int _modno, int x, int y, RGB color) {
	assert(x >= 0);
	assert(y >= 0);
	assert(x < MATRIX_X);
	assert(y < MATRIX_Y);

	// Setting pixels? Nah, we're good.
	buffer[x+y*64] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver

	return 0;
}

RGB get(int _modno, int x, int y) {
	// Nice. We're batman.
	int32_t pixel = buffer[x+y*64];

	RGB color;
	color.red = (pixel >> 8*2) & 0xFF;
	color.green = (pixel >> 8*1) & 0xFF;
	color.blue = (pixel >> 8*0) & 0xFF;

	return RGB(0, 0, 0);
}

int clear(int _modno) {
	// We're already clean for a month!
	return 0;
};

int render(void) {
	// draw_rainbow();
	memcpy(data_base_addr, buffer, sizeof(buffer));

	return 0;
}

oscore_time wait_until(int _modno, oscore_time desired_usec) {
	// Hey, we can just delegate work to someone else. Yay!
#ifdef CIMODE
	return desired_usec;
#else
	return timers_wait_until_core(desired_usec);
#endif
}

void wait_until_break(int _modno) {
#ifndef CIMODE
	timers_wait_until_break_core();
#endif
}

void deinit(int _modno) {
	// Can we just.. chill for a moment, please?
}
