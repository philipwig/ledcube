# Pattern Generator

Stay, Erase → Move, Write → Stay, Erase → Move, Write → Stay, Erase

When writing into mem_write_data <= B G R

the rightmost 0 or 1 is the lsb and the leftmost one is the msb

Pattern generator is getting called every single frame of the display. Lets say it is getting called at 290Hz (This is a 64 by 64 display with 8 bits per color and a lsb_len of 20)

New frame generated 1/5 times the patternbuffer is called. This means a new pattern frame is generated at 58Hz (290/5 = 58)

The next pattern happens after so many frames are generated

5*50=200 Pattern Gen calls

Lets say an animation takes 32 frames to complete

Want to do the animation 4 times so it will be a total of 128 frames 

I want those frames to happen over 2 seconds (2 animations a second)

128 frames / 2 seconds = 64 frames per second

Pattern generator is called 300 times per second

300 times/sec * 1/64sec/frame = 4.7 times / frame 

Use 5 as timer_max

300/5=60 frames per second

128/60 = 2.13 second animation length

60/32 = 1.875 animations per second

 

# Pattern Gen calculations

Here we are trying to calculate some constants n_display_frames and n_animation_frames for the pattern generator.

n_display_frames $= \text{number of display frames}$

n_animation_frames $= \text{frames per animation}$

The n_animation_frames is how many frames you want the animation to run for. For example if your animation takes 64 frames to do one cycle of it, but you want it to run 10 times use 64 as the number of animation frames for the calculations below but set n_animation_frames to 64*10. So set 64 frames per animation for the calculations below but n_animation_frames = 640 in the code.

## Equation

$$\frac{\text{display refresh rate}}{\text{frames per animation} * \text{animations per second}}=\text{display frames per animation frame}$$

## Example

Animation takes 32 frames to complete

Want to do 2 animations per second

$$32 \text{ frames} * 2 \text{ animations per second} = 64\text{ fps}$$

$$\frac{300 \text{ Hz}}{96 \text{ fps}} = 4.7 \text{ display frames per animation frame}$$

Choose 5 n_display_frames

$$\frac{300 \text{ Hz}}{5 \text{ display frames}} = 60 \text{ fps}$$

$$\frac{60 \text{ fps}}{32 \text{ frames}} = 1.875 \text{ animations per second}$$

With n_animation_frames = 32 and n_display_frames = 5, you get 1.875 animations per second

## Equation

$$\frac{\text{display refresh rate} * \text{seconds per animation}}{\text{frames per animation}} = \text{display frames per animation frame}$$

## Example

Animation takes 64 frames to complete

Want each animation to take 2 seconds

$$\frac{300 \text{ Hz} * 2}{64} = 9.4 \text{ display frames per animation frame}$$

Choose 9 n_display_frames

$$\frac{300 \text{ Hz}}{9 \text{ display frames}} = 33 \text{ fps}$$

$$\frac{64 \text{ animation frames}}{33 \text{ fps}} = 1.9 \text{ seconds per animation}$$

With n_animation_frames = 64 and n_display_frames = 9, you get 1.9 seconds per animation