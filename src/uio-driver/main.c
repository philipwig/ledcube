#include "uio-driver.h"
#include <stdio.h>


int main() {
    init("led_driver_test", "", "axi_bram_ctrl", "");

    
	int value = 0;

	while (1) {
        printf("\nInput 1 to enable driver, 0 to disable it, 3 to exit: ");
            scanf("%d", &value);

            if (value == 0) {
                printf("Disabling driver\n");
                write_ctrl(0, 0);
            }
            else if (value == 1) {
                printf("Enabling driver\n");
                write_ctrl(0, 0x3);

            }
            else if (value == 3) {
                break;
            }
            else if (value == 4) {
                // driver_config->data_base_addr[0] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0);
                write_data(64*64 - 3, 0xFFFFFFFF);
            }
            else if (value == 5) {
                // driver_config->data_base_addr[0] = (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0);
                write_data(64*64 - 3, 0);
            }
    }

    deinit();

    return 0;
}