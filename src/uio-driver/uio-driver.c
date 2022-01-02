#include "uio-driver.h"

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

// ******************* Config Variables ****************
static struct driver_config_t *driver_config = NULL;
static struct display_config_t *display_config = NULL;


// *************** Utility Functions ************************


/**
 * @brief Opens and maps a uio device. Returns pointer to mapped device
 * 
 * @param uio_num The number of the uio device to open
 * @param map_num The mapping number of the uio device
 * @param map Map of uio device to open
 * @return volatile uint32_t* The mapped address. MAP_FAILED if the map fails
 */
static volatile uint32_t *open_uio(int uio_num, int map_num, struct uio_map_t map) {
    // Check if the specified map exists
	if (map.size <= 0) {
        return (volatile uint32_t *) -1;
    }

    // Get the uio path to open
	char dev_name[16];
	sprintf(dev_name,"/dev/uio%d", uio_num);

    // Open the uio path and store the file descriptor
	int fd = open(dev_name, O_RDWR | O_SYNC);

    // Check if the file descriptor is negative
	if (fd < 0) {
        return (volatile uint32_t *) -1;
    }
    
    // Map the device
	volatile uint32_t *map_addr = (volatile uint32_t *) mmap(NULL, map.size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, map_num*getpagesize());
	
    // Close file descriptor
    close(fd);

    // Return mapped address
    return map_addr;
}


// ********************* Functions *********************

/**
 * @brief Initialize the driver
 * 
 * @param ctrl_name Name of the control uio device in the devicetree
 * @param ctrl_version Control uio version
 * @param data_name Name of the data uio device in the devicetree
 * @param data_version Data uio version
 * @return int 0 for success, 1 for error
 */
int *init(char *ctrl_name, char *ctrl_version, char *data_name, char *data_version) {
    // Create driver options struct and fill with names, version, and default values
    driver_config = (struct driver_config_t*) malloc(sizeof(struct driver_config_t));
    display_config = (struct display_config_t*) malloc(sizeof(struct display_config_t));

    strcpy(driver_config->ctrl_name, ctrl_name);
    strcpy(driver_config->ctrl_version, ctrl_version);
    driver_config->ctrl_uio_num = -1;
    driver_config->ctrl_map_num = 0;

    strcpy(driver_config->data_name, data_name);
    strcpy(driver_config->data_version, data_version);
    driver_config->data_uio_num = -1;
    driver_config->data_map_num = 1;


    display_config->num_rows = 64;
    display_config->num_cols = 64;

    display_config->bitdepth = 24;
    display_config->lsb_blank_time = 10;



    // Create variables to use when searching for uio devices
	struct uio_info_t *info_list, *p;
    int filter_num = -1;

    // Find all of the uio devices present and add them to the linked list info_list struct
    info_list = uio_find_devices(filter_num);

    // Check if no uio devices were found
	if (!info_list) {
        printf("No UIO devices found.\n");
    }
	
    // Put pointer at first element in info_list
	p = info_list;

    // Iterate through all uio devices searching for the ones we want
	while (p) {
        // Get all the information from the uio device
		uio_get_all_info(p);
		// uio_get_device_attributes(p);

        // TODO: ADD VERSION CHECKING AND EXIT EARLY IF BOTH ARE FOUND
        // Search for control uio device
        if (strcmp(p->name, driver_config->ctrl_name) == 0) {
            driver_config->ctrl_uio_num = p->uio_num;
            driver_config->maps[driver_config->ctrl_map_num] = p->maps[0]; // Hardcoded to 0 for now

            // Check to make sure pointers are not the same
            // printf("p pointer: %p\n", (void *) p);
            // printf("Control pointer: %p\n", (void *) control_uio);
        }
        
        // Search for data uio device
        // if (p->name == "led_panel_data" && p->version == "1") {
        // if (strcmp(p->name, "axi_bram_ctrl") == 0) {
        if (strcmp(p->name, driver_config->data_name) == 0) {
            driver_config->data_uio_num = p->uio_num; // Store the uio device number
            driver_config->maps[driver_config->data_map_num] = p->maps[0]; // Hardcoded to 0 for now

            // Check to make sure pointers are not the same
            // printf("p pointer: %p\n", (void *) p);
            // printf("Data pointer: %p\n", (void *) driver_config->maps);
        }

        p = p->next;		
	}

    // Free the info structs that were used
	uio_free_info(info_list);

    // printf("\n");
    // printf("driver_config data_uio_num: %d\n", driver_config->data_uio_num);
    // printf("driver_config data_map_num: %d\n", driver_config->data_map_num);
    // printf("driver_config data maps addr: %u\n", driver_config->maps[driver_config->data_map_num].addr);
    // printf("driver_config data maps addr: %#010x\n", driver_config->maps[driver_config->data_map_num].addr);
    // printf("driver_config data maps size: %u\n", driver_config->maps[driver_config->data_map_num].size);
    // printf("\n");

    if (driver_config->data_uio_num != -1) {
        driver_config->data_base_addr = open_uio(driver_config->data_uio_num,
                                                  0, // driver_config->data_map_num,
                                                  driver_config->maps[driver_config->data_map_num]);
        // printf("Opened data uio\n");
    }

    // printf("\n");
    // printf("driver_config ctrl_uio_name: %d\n", driver_config->ctrl_uio_num);
    // printf("driver_config ctrl_map_num: %d\n", driver_config->ctrl_map_num);
    // printf("driver_config ctrl maps addr: %u\n", driver_config->maps[driver_config->ctrl_map_num].addr);
    // printf("driver_config ctrl maps addr: %#010x\n", driver_config->maps[driver_config->ctrl_map_num].addr);
    // printf("driver_config ctrl maps size: %u\n", driver_config->maps[driver_config->ctrl_map_num].size);
    // printf("\n");

    // If the control or data uio devices were found, mmap them
    if (driver_config->ctrl_uio_num != -1) {
        driver_config->ctrl_base_addr = open_uio(driver_config->ctrl_uio_num,
                                                  0, // driver_config->ctrl_map_num,
                                                  driver_config->maps[driver_config->ctrl_map_num]);
        // printf("Opened control uio\n");
    }

    // printf("\n");
    // printf("ctrl_base_addr: %p\n", (void *) driver_config->ctrl_base_addr);
    // printf("data_base_addr: %p\n", (void *) driver_config->data_base_addr);
    // printf("\n");

    return 0;
}


/**
 * @brief Deinitialize the driver
 * 
 * TODO: Add error checking fo munmap. Also check if the memory has been mapped
 * 
 * @return int 0 for success, 1 for error
 */
int deinit() {
	munmap((void *) driver_config->ctrl_base_addr, driver_config->maps[driver_config->ctrl_map_num].size);
	munmap((void *) driver_config->data_base_addr, driver_config->maps[driver_config->data_map_num].size);
    free(driver_config);
    driver_config = NULL;
    printf("\nClosed and freed all\n");
    return 0;
}

/**
 * @brief Write to the control memory map
 * 
 * @param offset What memory address to write to. Must be less than the mapped memory size
 * @param value The value to write to the memory. Must be 32 bits
 * @return int 0 if successful, 1 if error
 */
int write_ctrl(uint32_t offset, uint32_t value) {
    if (driver_config == NULL || driver_config->ctrl_uio_num < 0) {
        printf("WARNING: Need to initialize driver\n");
        return 1;
    }

    if (offset < driver_config->maps[driver_config->ctrl_map_num].size) {
        driver_config->ctrl_base_addr[offset] = value;
        return 0;
    }

    return 1;
}

/**
 * @brief Write to the data memory map
 * 
 * @param offset What memory address to write to. Must be less than the memory mapped size
 * @param value The value to write to memory. Must be 32 bits
 * @return int 0 if successful, 1 if error
 */
int write_data(uint32_t offset, uint32_t value) {
    if (driver_config == NULL || driver_config->ctrl_uio_num < 0) {
        printf("WARNING: Need to initialize driver\n");
        return 1;
    }

    if (offset < driver_config->maps[driver_config->data_map_num].size) {
        driver_config->data_base_addr[offset] = value;
        return 0;
    }

    return 1;
}

/**
 * @brief Write the given config to the panel
 * 
 * @param user_display_config The new config to use. 
 * Note: values are copied internally so you have to call this function everytime the config changes
 * 
 * TODO: Add checks for valid config values and write_ctrl return values
 * 
 * @return int 0 if successful, 1 if error
 */
int write_config(struct display_config_t *user_display_config) {
    *display_config = *user_display_config; // Copy the user config to the global config

    write_ctrl(N_ROWS_OFFSET, display_config->num_rows);
    write_ctrl(N_COLS_OFFSET, display_config->num_cols);
    write_ctrl(BITDEPTH_OFFSET, display_config->bitdepth);
    write_ctrl(LSB_LENGTH_OFFSET, display_config->lsb_blank_time);
    
    return 0;
}

/**
 * @brief Gets the current configured number of rows
 * 
 * @return int Number of rows
 */
int get_num_rows() {
    return display_config->num_rows;
}

/**
 * @brief Gets the current configured number of columns
 * 
 * @return int Number of columns
 */
int get_num_cols() {
    return display_config->num_cols;
}




// *************** Display Functions ************************

/**
 * @brief Set value of a pixel
 * 
 * @param x X coordinate of pixel
 * @param y Y coordinate of pixel
 * @param color Color of the pixel
 * @return int 0 if successful, 1 if error
 */
int set_pixel(int x, int y, RGB color) {
    if (x < display_config->num_cols && y < display_config->num_rows) {
        return write_data(x + y*display_config->num_cols, RGB2UINT(color));
    }

    return 1;
}

/**
 * @brief Get the current value of a pixel
 * 
 * @param x X coordinate of pixel
 * @param y Y coordinate of pixel
 * @return uint32_t Value of the pixel if successful, -1 if error
 */
uint32_t get_pixel(int x, int y) {
    return driver_config->data_base_addr[x + y*64];
}


/**
 * @brief Sets every pixel of display
 * 
 * @param color Color to set the display to
 * @return int 0 if successful, 1 if error
 */
int fill_display(RGB color) {
    for (int x = 0; x < display_config->num_cols; x++) {
        for (int y = 0; y < display_config->num_rows; y++) {
            set_pixel(x, y, color);
        }
    }

    return 0;
}


int clear_display() {
    return 0;
}
