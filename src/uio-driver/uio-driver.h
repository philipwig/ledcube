#ifndef UIO_DRIVER_H
#define UIO_DRIVER_H



/* This should be identical to the define in include/linux/uio_driver.h */
#define MAX_UIO_MAPS 	5




#define UIO_MAX_NAME_SIZE	64


#define CONTROL_OFFSET 0
#define N_ROWS_OFFSET 1
#define N_COLS_OFFSET 2
#define BITDEPTH_OFFSET 3 
#define LSB_LENGTH_OFFSET 4


#include <stdint.h>

#include "include/uio_helper.h"
#include "include/color.h"

struct display_config_t {
    int num_rows;
    int num_cols;
    int bitdepth;
    int lsb_blank_time;
    // int brightness;
    // int scan_mode;
};

struct driver_config_t {
    // ******* Control Register *******
    char ctrl_name [UIO_MAX_NAME_SIZE]; // Name of the uio device
    char ctrl_version [UIO_MAX_NAME_SIZE]; // Version of the uio device
    int ctrl_uio_num; // Uio device number /dev/uioX, -1 if not set
    int ctrl_map_num; // Which map in the maps array

    volatile uint32_t *ctrl_base_addr; // The mapped address of the control registers
    // volatile tips https://barrgroup.com/embedded-systems/how-to/c-volatile-keyword

    // ******* Data Register *******
    char data_name [UIO_MAX_NAME_SIZE]; // Name of the uio device
    char data_version[UIO_MAX_NAME_SIZE]; // Version of the uio device
    int data_uio_num; // Uio device number /dev/uioX
    int data_map_num; // Which map in the maps array

    volatile uint32_t *data_base_addr; // The mapped address of the control registers


	struct uio_map_t maps[MAX_UIO_MAPS]; // Stores uio map information
};


int *init(char *ctrl_name, char *ctrl_version, char *data_name, char *data_version);
int deinit();

int write_ctrl(uint32_t offset, uint32_t value);
int write_data(uint32_t offset, uint32_t value);

int write_config(struct display_config_t *user_display_config);
int get_num_rows();
int get_num_cols();

int set_pixel(int x, int y, RGB color);
uint32_t get_pixel(int x, int y);

int fill_display(RGB color);

// ********** Utility Functions *******************
// volatile uint32_t *open_uio(int uio_num, int map_num, struct uio_map_t map);

#endif