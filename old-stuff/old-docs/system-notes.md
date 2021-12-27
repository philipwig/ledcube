3 Part system
- ARM CPU
    - Responsible for generating the graphics that will be shown on the display
    - Written in C/C++ or whatever language you like
    - Interfaces to the fpga fabric through a driver
    - Easy to work with using a standard interface
- FPGA Panel driver
    - Drives the led panel using the data from the CPU
    - Responsible for the frames that will be displayed and is strictly a real time system
    - Takes input from the cpu and translates it into something that can be displayed on the panel
- Possibly a custom graphics accelerator if the cpu isn’t able to generate the display frames fast enough

Mechanical Design
- Use the kbob frame. Maybe modify to be able to put something in front of the panels to protect them. Some sort of acrylic diffuser or something might be nice.
- Spring loaded battery holder to make sure that the battery is not banging around inside the cube. Everything else can be hard mounted to the frame. Kbob cube uses a 3d printed one but metal springs might be easier to use.
Electrical power supply design
- Power supply for the processor board whichever one that is
- Power supply for the led panels. 15A at 4V for panels. Adjustable output voltage is useful because of a variety of panels as you might need to adjust it for the panels or other io reasons.
- IMU and softpower on/off button.
- Might want to try adding a way to charge the battery without having to take it out and charge separately.
- Add some way to get audio into the system. Might just be easier 

Need to create
- Simulator that simulates the operation of the FPGA so that can write programs for the arm cpu easier and quicker without having to actually have a fpga and led panel set up
- A driver to interface the CPU to the fpga fabric
- The led panel driver inside of the fpga to drive the actual panels



FPGA Driver
- RAM to store 2 frames from the CPU. This is where the cpu will write the data to be shown on the display. Need some sort of signal so that the CPU knows which buffer to write to
- Take the RAM data from one of the frambuffers and write it to the display. Rinse and repeat switching between the buffers so that the CPU can write new frames to be displayed.

CPU Driver
- Design an interface that is easy to use that abstracts away some of the hard parts of drawing frames. Possibly model after the rpi-rgb-led-matrix library that we were using before.



FPGA driver
- Use binary code modulation not PWM to display the colors on the LEDs. 
- Might be useful to design the system to split the panels into smaller groups to be able to drive them faster. This is limited by the amount of i/o pins that are on the fpga


Power supply
- Has to be able to power the cube entirely. 
- Some sort of switching power supply. See kbobs one to inspiration. Also the one from the squarewave design, this one is close to what we will need.
- Outputs for FPGA as well as the led panels
- Incorporate sensors onto the same PCB?
- For the snickerdoodle board it can just be a board that attaches directly to it

Frame for the cube
- How to open and close the cube easily.
- Could have a hindge 
- Use frame with one panel held on with magnets. Some sort of pull tab to open it up
- Maybe some servos or some kind of mechanical latch to keep it closed. Make sure it is able to open without power.
- 3D printed brackets to go around each of the panels but maybe some sort of metal internal frame to give it more rigidity. Aluminum extrusion or something similar.

Batteries

Sensors
- Accelerometer/gyroscope so that it can sense position and rotations.
- Light/sound sensor so that it can react to external input
- Some sort of remote control, others have noted that it is still possible ot use Bluetooth and Wi-Fi through the cube. Have to test the range on something like that.
- Temperature probe to monitor temperature inside and outside of the cube. Monitor the battery temperature to be safe

Control/driving leds

Software
- Create a simulator so that it is easier to develop software to run on the cube without actually having to have the cube to test the designs. Try to emulate the cube as closelyas possible.
- Write software to run the cube before hardware is done so that we limit the amount of hardware modifications we have to do

Diffuser for the panels
- While 3mm plexiglass
