#include "uio-driver.h"
#include <stdio.h>
#include <time.h>

double time_used_us(clock_t start, clock_t end, double num_runs) {
    return ((double) (end - start)) / (CLOCKS_PER_SEC * num_runs) * 1E6;
}


int main() {

    clock_t start, end;
    int i, num_runs = 64*64;


    // **************************************************************
    start = clock();

    init("led_driver_test", "", "axi_bram_ctrl", "");

    end = clock();
    printf("Init: %03f us each call\n", time_used_us(start, end, 1));
    // **************************************************************



    // **************************************************************
    start = clock();
    
    write_ctrl(0, 0);

    end = clock();
    printf("write_ctrl: %03f us each call\n", time_used_us(start, end, 1));
    // **************************************************************



    // **************************************************************
    start = clock();
    
    write_data(64*64 - 3, 0xFFFFFFFF);

    end = clock();
    printf("write_data: %03f us each call\n", time_used_us(start, end, 1));
    // **************************************************************



    // **************************************************************
    start = clock();

    for (i = 0; i < num_runs; i++) {
        write_ctrl(0, 0);
    }

    end = clock();
    printf("%d write_crtl: %f us total\n", num_runs, time_used_us(start, end, (double) 1));
    printf("%d write_crtl: %f us each call\n", num_runs, time_used_us(start, end, (double) num_runs));
    // **************************************************************



    // **************************************************************
    start = clock();

    for (i = 0; i < num_runs; i++) {
        write_data(64*64 - 3, 0xFFFFFFFF);
    }

    end = clock();
    printf("%d write_data: %03f us total\n", num_runs, time_used_us(start, end, (double) 1));
    printf("%d write_data: %03f us each call\n", num_runs, time_used_us(start, end, (double) num_runs));
    // **************************************************************
    
    num_runs = 64*64*300;

    // **************************************************************
    start = clock();

    for (i = 0; i < num_runs; i++) {
        write_ctrl(0, 0);
    }

    end = clock();
    printf("%d write_crtl: %f us total\n", num_runs, time_used_us(start, end, (double) 1));
    printf("%d write_crtl: %f us each call\n", num_runs, time_used_us(start, end, (double) num_runs));
    // **************************************************************



    // **************************************************************
    start = clock();

    for (i = 0; i < num_runs; i++) {
        write_data(64*64 - 3, 0xFFFFFFFF);
    }

    end = clock();
    printf("%d write_data: %03f us total\n", num_runs, time_used_us(start, end, (double) 1));
    printf("%d write_data: %03f us each call\n", num_runs, time_used_us(start, end, (double) num_runs));
    // **************************************************************



    // **************************************************************
    start = clock();

    for (i = 0; i < 64*64; i++) {
        write_data(i, 0xFFFFFFFF);
    }

    end = clock();
    printf("Full display write_data: %03f us total\n", 64*64, time_used_us(start, end, (double) 1));
    printf("Full display write_data: %03f us each call\n", 64*64, time_used_us(start, end, (double) 64*64));
    // **************************************************************

    deinit();

    return 0;
}