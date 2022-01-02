#include "uio-driver.h"
#include <stdio.h>


#include <linux/random.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

RGB off = {0, 0, 0};
RGB white = {255, 255, 255};

struct particle_t {
    double x, y;
    double vx, vy;
    double m, g;
    int disp_x, disp_y;
    int updated;
};

// struct particle_t *particles;
#define NUM_PARTICLES 30
struct particle_t *particles;

#define CONSTANT_VY 0.01 // Smaller is weaker, bigger is stronger
#define V_CONSERV 0.9 // Closer to 1 is more conservative, closer to 0 slows down faster


void delay(int number_of_seconds)
{
    // Converting time into milli_seconds
    int milli_seconds = 1000 * number_of_seconds;
  
    // Storing start time
    clock_t start_time = clock();

    int i = 0;
  
    // looping till required time is not achieved
    while (clock() < start_time + milli_seconds)
        i++;
}

/* generate a random floating point number from min to max */
double randfrom(double min, double max) {
    double range = (max - min); 
    // double div = ((double) 32767) / range;
    double div = RAND_MAX / range;
    return min + (rand() / div);
}


void do_something(struct particle_t *particles, int num_particles) {
 
    for (int i = 0; i < num_particles; i++) {

        // Update x checking for bounds
        particles[i].disp_x = (int) round(particles[i].x + particles[i].vx);
        if (particles[i].disp_x < (64 - 1) && particles[i].disp_x >= 0) {
            particles[i].x += particles[i].vx;
        }
        else {
            particles[i].vx = -(V_CONSERV * particles[i].vx);
            particles[i].x += particles[i].vx;
        }

        particles[i].disp_x = (int) round(particles[i].x);


        // Update y checking for bounds
        particles[i].disp_y = (int) round(particles[i].y + particles[i].vy);
        if (particles[i].disp_y < (64 - 1) && particles[i].disp_y >= 0) {
            particles[i].y += particles[i].vy;
        }
        else {
            particles[i].vy = -(V_CONSERV * particles[i].vy);
            particles[i].y += particles[i].vy;
        }

        particles[i].vy += CONSTANT_VY;

        particles[i].disp_y = (int) round(particles[i].y);


        // printf("x: %f\n", particles[i].x);
        // printf("y: %f\n", particles[i].y);

        particles[i].updated = 0;
    }

    for (int i = 0; i < num_particles; i++) {
        for (int j = 0; j < num_particles; j++) {
            if (i != j) { // Its the same particle
                if(particles[i].disp_x == particles[j].disp_x && particles[i].disp_y == particles[j].disp_y) { // In the same position
                    if(!particles[i].updated || !particles[j].updated) { // At least one hasn't been updated yet because of collision
                        particles[i].vx = -(V_CONSERV * particles[i].vx);
                        particles[i].vy = -(V_CONSERV * particles[i].vy);

                        particles[j].vx = -(V_CONSERV * particles[j].vx);
                        particles[j].vy = -(V_CONSERV * particles[j].vy);

                        particles[i].updated = 1;
                        particles[j].updated = 1;
                    }
                }
            }
        }
    }
}





int main() {
    srand(time(0));
    printf("START\n");

    init("led_driver_test", "", "axi_bram_ctrl", "");

    printf("INIT DONE\n");

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
        else if (value > 3) {
            printf("Running particles with %i particles\n", value);

            particles = malloc(value * sizeof(struct particle_t));

            // Initialize particles
            for (int i = 0; i < value; i++) {
                particles[i].x = randfrom(0, 64 - 1);
                particles[i].y = randfrom(0, 64 - 1);

                particles[i].vx = randfrom(-1, 1);
                particles[i].vy = randfrom(-1, 1);

                particles[i].disp_x = (int) round(particles[i].x);
                particles[i].disp_y = (int) round(particles[i].y);


                // printf("x: %f\n", particles[i].x);
                // printf("y: %f\n", particles[i].y);
                // printf("vx: %f\n", particles[i].vx);
                // printf("vy: %f\n\n", particles[i].vy);
            }

            printf("Enabling driver\n");

            write_ctrl(N_ROWS_OFFSET, 64);
            write_ctrl(N_COLS_OFFSET, 64);
            write_ctrl(LSB_LENGTH_OFFSET, 20);
            write_ctrl(0, 0x3);
            fill_display(off);


            while (1) {
                // Remove previous pixels
                // printf("REMOVE PIXELS\n");

                fill_display(off);

                do_something(particles, value);

                // Set next pixel 
                for (int i = 0; i < value; i++) {
                    // matrix_set(particles[i].disp_x, particles[i].disp_y, white);
                    // set_pixel(particles[i].disp_x, particles[i].disp_y, white);
                    write_data(particles[i].disp_x + particles[i].disp_y*get_num_cols(), 0xFFFFFFFF);
                }

                delay(10);
            }
        }
    }

    deinit();

    return 0;
}