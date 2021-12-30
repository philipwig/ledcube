struct display_options_t {
    int rows;
    int cols;
    int bitdepth;
    int lsb_blank_time;
    // int brightness;
    // int scan_mode;
};

struct uio_options_t {
    char control_name [255];
	char control_version[255];

    char data_name [255];
	char data_version [255];

};


int init();
