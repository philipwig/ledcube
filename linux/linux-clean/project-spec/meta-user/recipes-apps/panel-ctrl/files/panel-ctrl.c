/*
   lsuio - List UIO devices.

   Copyright (C) 2007 Hans J. Koch

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License version 2 as
   published by the Free Software Foundation.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

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
#include "include/system.h"
#include "include/uio_helper.h"
#include <string.h>

#include <signal.h>

#include <poll.h>
#include <time.h>
#include <sys/time.h>


#include "include/color.h"

#define EXIT_FAILURE 1




#define CONTROL_OFFSET 0
#define N_ROWS_OFFSET 4
#define N_COLS_OFFSET 8
#define BITDEPTH_OFFSET 12
#define LSB_LENGTH_OFFSET 16
#define BRIGHTNESS_OFFSET 20
#define BUFFER_OFFSET 24






static void usage (int status);
static void version (int status);

/* The name the program was run with, stripped of any leading path. */
char *program_name;

/* Option flags and variables */


static struct option const long_options[] =
{
  {"help", no_argument, 0, 'h'},
  {"mmap", no_argument, 0, 'm'},
  {"uiodev", required_argument, 0, 'u'},
  {"verbose", no_argument, 0, 'v'},
  {"version", no_argument, 0, 'V'},
  {NULL, 0, NULL, 0}
};


int opt_mmap;
int opt_verbose;
int opt_uiodev;
int opt_help;
int opt_version;

int uio_filter;

static int decode_switches (int argc, char **argv);
static void show_uio_info(struct uio_info_t *info);






int32_t *ctrl_base_addr;
int32_t *data_base_addr;


void fill_panel(int32_t color) {
	static int32_t buffer[64*64];

	for(unsigned int j = 0; j < 64*64; j = j + 1) {
		buffer[j] = color;
	    // data_base_addr[j] = color; // Need to set to a hex 3 to enable the led_panel_driver
	}

	memcpy(data_base_addr, buffer, sizeof(buffer));
}


void matrix_set(int x, int y, RGB color) {
	static int32_t buffer[64*64];

	if (x < 64 && y < 64 && x >= 0 && y >= 0) {
	    // *((unsigned *)(data_base_addr + (x + y*64) * 4)) = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
		// data_base_addr[x+y*64] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
		buffer[x+y*64] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
	}

	memcpy(data_base_addr, buffer, sizeof(buffer));
}

#define FRAMES 255
#define FRAMETIME ((TIME_SHORT * T_SECOND) / 255)

static int pos = 0;
static int frame = 0;
static int buffer = 0;

int draw_rainbow() {
	int x;
	int y;

	static int32_t buffer[64*64];
	static int32_t buffer2[64*64];

	for (y = 0; y < 64; ++y) {
		for (x = 0; x < 64; ++x) {
			RGB color = HSV2RGB(HSV(pos + x, 255, 255));
			// matrix_set(x, y, color);
			buffer[x+y*64] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
			// data_base_addr[x+y*64] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0); // Need to set to a hex 3 to enable the led_panel_driver
		}
	}

	memcpy(data_base_addr, buffer, sizeof(buffer));
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



int fd_ctrl, fd_data;


void termination_handler (int signum) {
	if (ctrl_base_addr != NULL)
		ctrl_base_addr[0] = 0;
		ctrl_base_addr[0] = 2;
		ctrl_base_addr[0] = 0;

	if (fd_ctrl > 0) {
		close(fd_ctrl);
	}

	if (fd_data > 0) {
		close(fd_data);
	}

	printf("\nExiting program\n");
	exit (0);
}


int main (int argc, char **argv)
{
	if (signal (SIGINT, termination_handler) == SIG_IGN)
		signal (SIGINT, SIG_IGN);
	if (signal (SIGHUP, termination_handler) == SIG_IGN)
		signal (SIGHUP, SIG_IGN);
	if (signal (SIGTERM, termination_handler) == SIG_IGN)
		signal (SIGTERM, SIG_IGN);



	struct uio_info_t *info_list, *p;

	program_name = argv[0];

	decode_switches (argc, argv);

	if (opt_help)
		usage(0);

	if (opt_version)
		version(0);

	info_list = uio_find_devices(uio_filter);
	if (!info_list)
		printf("No UIO devices found.\n");

	p = info_list;


	struct uio_info_t *uio_ctrl, *uio_data;

	while (p) {
		uio_get_all_info(p);
		if (opt_verbose) uio_get_device_attributes(p);
		if (opt_mmap) uio_mmap_test(p);
		// show_uio_info(p);

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


	int bright = 0;
	int lsb_blank_len = 10;

	double time_spent = 0, time_waited = 0;
	static struct timeval  tv1, tv2;

	static struct timeval t1, t2;

// 	clock_t begin = clock();

// /****  code ****/

// clock_t end = clock();
// double time_spent = (double)(end - begin) //in microseconds

	// gettimeofday(&t1, NULL);

	while (1) {
		// ctrl_base_addr[6] = 0;
		// fill_panel(0xFFFFFF00);
		// sleep(1);
		// ctrl_base_addr[6] = 1;
		// fill_panel(0x000000FF);
		// sleep(1);

		// ctrl_base_addr[6] = 0;
		// draw_rainbow();


		// if (bright >= 20) bright = 0;
		// else bright++;
		// sleep(1);




		// gettimeofday(&t2, NULL);
		// time_waited = (t2.tv_sec - t1.tv_sec);
		// // printf("Waited %f us\n", time_waited);

		// if (time_waited >= 1) {
		// 	if (lsb_blank_len >= 20) lsb_blank_len = 1;
		// 	else lsb_blank_len++;
			
		// 	ctrl_base_addr[4] = lsb_blank_len;
		// 	printf("\n\n\t\t Changed LSB length \n\n");


		// 	gettimeofday(&t1, NULL);
		// }





		// sleep(1);

		// usleep(100000);
		// sleep(1);

		// ctrl_base_addr[6] = 1;
		// draw_rainbow();

	/**
	 * cat /proc/interrupts
	 * 
	 */


		// uint32_t info = 1; /* unmask */

        // ssize_t nb = write(fd_ctrl, &info, sizeof(info));
        // if (nb != (ssize_t)sizeof(info)) {
        //     perror("write");
        //     close(fd_ctrl);
        //     exit(EXIT_FAILURE);
        // }

        // struct pollfd fds = {
        //     .fd = fd_ctrl,
        //     .events = POLLIN,
        // };


        // int ret = poll(&fds, 1, -1);
        // if (ret >= 1) {
        //     nb = read(fd_ctrl, &info, sizeof(info));
        //     if (nb == (ssize_t) sizeof(info)) {
        //         /* Do something in response to the interrupt. */
		// 		end = clock();
		// 		time_spent = (double)(end - begin); //in microseconds
        //         printf("Interrupt #%u!\n", info);
        //         printf("Spent %f us\n", time_spent);
        //         printf("nb: %zd\n", nb);
		// 		begin = clock();
        //     }
        // } else {
        //     perror("poll()");
        //     close(fd_ctrl);
        //     exit(EXIT_FAILURE);
        // }

		// uint32_t info = 1; /* unmask */

        // ssize_t nb = write(fd_ctrl, &info, sizeof(info));
        // if (nb != (ssize_t)sizeof(info)) {
        //     perror("write");
        //     close(fd_ctrl);
        //     exit(EXIT_FAILURE);
        // }

        // /* Wait for interrupt */
        // nb = read(fd_ctrl, &info, sizeof(info));
        // if (nb == (ssize_t)sizeof(info)) {
        //     /* Do something in response to the interrupt. */
		// 		end = clock();
		// 		time_spent = (double)(end - begin); //in microseconds
		// 		begin = clock();
		// 		// draw_rainbow();
        //         printf("Interrupt #%u!\n", info);
        //         printf("Spent %f us\n", time_spent);
        //         printf("nb: %zd\n", nb);
		// }


		// uint32_t info = 1; /* unmask */

        // ssize_t nb = write(fd_ctrl, &info, sizeof(info));
        // if (nb != (ssize_t)sizeof(info)) {
        //     perror("write");
        //     close(fd_ctrl);
        //     exit(EXIT_FAILURE);
        // }

        // /* Wait for interrupt */
        // nb = read(fd_ctrl, &info, sizeof(info));
        // if (nb == (ssize_t)sizeof(info)) {
        //     /* Do something in response to the interrupt. */
		// 		// gettimeofday(&tv2, NULL);
		// 		// time_spent = (double) (tv2.tv_usec - tv1.tv_usec) / 1000000; // + (double) (tv2.tv_sec - tv1.tv_sec);
		// 		// time_spent = (double) (tv2.tv_usec - tv1.tv_usec); // + (double) (tv2.tv_sec - tv1.tv_sec);
		// 		// gettimeofday(&tv1, NULL);
		// 		// draw_rainbow();
		// 		draw_x_line();
		// 		usleep(5000);


        //         // printf("Interrupt #%u!\t", info);
        //         // printf("Spent %f us\n", time_spent);
		// }




		// gettimeofday(&tv2, NULL);
		// time_spent = (double) (tv2.tv_usec - tv1.tv_usec); // + (double) (tv2.tv_sec - tv1.tv_sec);
		// gettimeofday(&tv1, NULL);
		draw_rainbow();
		// fill_panel(20);
		// draw_x_line();
		// printf("Spent %f us\n", time_spent);



		// struct timeval  tv1, tv2;
		// gettimeofday(&tv1, NULL);
		// /* stuff to do! */
		// gettimeofday(&tv2, NULL);

		// printf ("Total time = %f seconds\n",
		//          (double) (tv2.tv_usec - tv1.tv_usec) / 1000000 +
		//          (double) (tv2.tv_sec - tv1.tv_sec));
		// draw_rainbow();



		// end = clock();
		// time_spent = (double)(end - begin); //in microseconds
		// begin = clock();
		// draw_rainbow();
        // printf("Spent %f us\n", time_spent);

	}


	// ********** unmap **********
	munmap(ctrl_base_addr, uio_ctrl->maps[0].size);
	printf("Closed ctrl uio\n");

	munmap(data_base_addr, uio_data->maps[0].size);
	printf("Closed data uio\n");
	// *****************************

	uio_free_info(info_list);
	exit (0);
}

static void show_device(struct uio_info_t *info)
{
	char dev_name[16];
	sprintf(dev_name,"uio%d",info->uio_num);
	printf("%s: name=%s, version=%s, events=%ld\n",
	       dev_name, info->name, info->version, info->event_count);
}

static int show_map(struct uio_info_t *info, int map_num)
{
	if (info->maps[map_num].size <= 0)
		return -1;

	printf("\tmap[%d]: addr=0x%08lX, size=%d",
	       map_num,
	       info->maps[map_num].addr,
	       info->maps[map_num].size);
	if (info->maps[map_num].offset)
		printf(", offset=0x%X", info->maps[map_num].offset);

	if (opt_mmap) {
		printf(", mmap test: ");
		switch (info->maps[map_num].mmap_result) {
			case UIO_MMAP_NOT_DONE:
				printf("N/A");
				break;
			case UIO_MMAP_OK:
				printf("OK");
				break;
			default:
				printf("FAILED");
		}
	}
	printf("\n");
	if (info->maps[map_num].name[0])
		printf("\t\tname=%s\n", info->maps[map_num].name);
	return 0;
}

static void show_dev_attrs(struct uio_info_t *info)
{
	struct uio_dev_attr_t *attr = info->dev_attrs;
	if (attr)
		printf("\tDevice attributes:\n");
	else
		printf("\t(No device attributes)\n");

	while (attr) {
		printf("\t%s=%s\n", attr->name, attr->value);
		attr = attr->next;
	}

}

static void show_maps(struct uio_info_t *info)
{
	int ret;
	int mi = 0;
	do {
		ret = show_map(info, mi);
		mi++;
	} while ((ret == 0)&&(mi < MAX_UIO_MAPS));
}

static void show_uio_info(struct uio_info_t *info)
{
	show_device(info);
	show_maps(info);
	if (opt_verbose) show_dev_attrs(info);
}

/* Set all the option flags according to the switches specified.
   Return the index of the first non-option argument.  */

static int decode_switches (int argc, char **argv)
{
	int opt, opt_index = 0;
	opt_mmap = 0;
	opt_help = 0;
	opt_uiodev = 0;
	opt_version = 0;
	opt_verbose = 0;
	uio_filter = -1;

	while (1) {
		opt = getopt_long(argc,argv,"hmu:vV",long_options,&opt_index);
		if (opt == EOF)
			break;
		switch (opt) {
			case 'm' : opt_mmap = 1;
				   break;
			case 'u' : opt_uiodev = 1;
				   uio_filter = atoi(optarg);
				   break;
			case 'v' : opt_verbose = 1;
				   break;
			case 'h' : opt_help = 1;
				   break;
			case 'V' : opt_version = 1;
				   break;
		}
	}

	return 0;
}


static void usage (int status)
{
  printf (_("%s - List UIO devices.\n"), program_name);
  printf (_("Usage: %s [OPTIONS]\n"), program_name);
  printf (_("\
Options:\n\
  -h, --help       display this help and exit\n\
  -m, --mmap       test if mmap() works for all mappings\n\
  -u, --uiodev N   only probe /dev/uioN\n\
  -v, --verbose    also display device attributes\n\
  -V, --version    output version information and exit\n\
"));
  exit (status);
}

static void version (int status)
{
  printf ("1.0.0\n");
  exit (status);
}