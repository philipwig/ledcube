BCM Module
==========

The bcm module is responsible for shifting the data into the shift
registers on the display. It controls the display clk, address, and RGB
lines. To display more than 1 bit worth of colors, binary coded
modulation (BCM) is used to allow the display to reach higher levels of
color depth.

BCM is used over pulse width modulation (PWM) because it is easier to
program for with the FPGA fabric as well as allowing for easier
flexibility with a different number of bits for color.

The display can be programmed to display as many colors as you want
using BCM, but with the tradeoff that each additional bit of color adds
2^n to the amount of time that is needed to refresh the display. So if 1
bit of color takes 1 unit of time to refresh the entire display, 2 bits
will take 3 total, 1 for the first bit and 2 for the second, 3 bits will
take 7 units, 1 for the first, 2 for the second and 4 for the third. As
you can see, the amount of time that it takes to refresh the display is
exponentially related to the number of bits of color that you want to
display.

To maybe help explain some terminology or confuse you even more, there
are different ways of thinking about the bits that make up an image.

A piece of terminology that you might see is the use of bitplanes. A
bitplane is a way to think about or to store a picture where each plane
(of bits/color) is all the bits of the image in a particular bit
position. See the `wikipedia article <https://en.wikipedia.org/wiki/Bit_plane>`_ 
for more information.

This can be a useful way of thinking about the images being displayed on
the led panel as each plane of the image corresponds to one bit of bcm.
So at a particular pixel you take the first bit from the first bitplane
at that pixel, the second bit from the second bitplane and so on. This
makes it easy to talk about refreshing the display in terms of
bitplanes. Bitplanes can also be a way to organize the frames into the
ram so they can be stored before they are displayed. Note that in the
current driver the ram is not organized in this way.

Calculating Refresh Rate
------------------------

The equation to calculate the number of cycles needed to refresh refresh
a row of leds on the panel using bcm modulation is shown below, where
:math:`r` is the number of rows, :math:`b` is the bitdepth, and
:math:`l` is the lsb cycle time.

.. math:: \text{BCM cycles} = r \sum_{i=0}^{b-1} \Bigg[ l\ 2^i \Bigg]

This equation does not take into account the amount of time that is
needed to shift data into the shift registers on the display. To correct
this week need the number of columns on the display which is represented
with :math:`c`. The equation above is only valid for calculating refresh
rate when :math:`l > c`. This equation will be useful later when
calculating light efficiency.

The correct equation for calculating the number of cycles needed to
refresh the display is shown below where :math:`r` is the number of
rows, :math:`b` is the bitdepth, :math:`l` is the lsb cycle
time, :math:`c` is the number of columns, and :math:`H` is the
overhead of the display driver

.. math:: \text{display cycles} = r \sum_{i=0}^{b-1} \Bigg[ \text{max} \Big\{ l\ 2^i, c \Big\}  + H \Bigg]

Below is an example of how to use the equation with 32 as the number of
rows, 8 as the bitdepth, 20 as the lsb cycle time, 32 as the number of
columns, and 3 as the overhead.

.. math:: r=32, b=8, l=20, c=32, H=3\\ 32  \sum_{i=0}^{8-1} \Bigg[ \text{max} \Big\{ 20* 2^i, 32 \Big\}  + 3 \Bigg] = 164352 \text{ cycles}

This number of cycles is how many clock cycles that are needed to
refresh a display using bcm modulation. To convert this number to a
refresh rate we simply need to divide the frequency of our display clock
by the number of cycles calculated above. This equation is shown below

.. math:: \text{refresh rate} = \frac{f}{cycles}

As an example, using the number of cycles that was calculated above and
a clock frequency of 25 MHz, the corresponding refresh rate is shown
below

.. math:: \frac{25000000}{164352 } = 152.11 \text{ Hz}

The refreshes per second is how fast the display is updating so a higher
number here will look better to the eyes and to cameras. This number is
also sometimes referred to as the refresh rate of the display, and is
usually measured in units of Hz. When the refresh rate is 100 -120 Hz or
above, cameras taking video will usually display minimal flickering.
Once the refresh rate is below this, the exposure time or shutter speed
of the camera is getting close to the refresh rate of the display which
will cause visible flickering and tearing to be seen in the video of the
display. To avoid flickering for the human eye, you can go lower than
this but the higher the refresh rate of the display is the better it
will look so aim to keep this as high as possible. Somewhere between 60
- 80 Hz is usually an acceptable low end range for human vision.

Calculating Light Efficiency
----------------------------

The light efficiency is a percentage that represents the amount of time
that each row of the display is actually on compared to the theoretical
maximum time that it could be on. This difference comes from the fact
that time is needed to shift data into the shift registers on the
display as well as time to latch that data into the output registers so
that it can be shown. The shifting of data into the shift registers can
happen when the row is illuminated to lessen its effect but the time
needed to latch the registers has to happen when the display is off.

To calculate the time theoretically needed for bcm modulation of the
display, the equation below is used where :math:`r` is the number of
rows, :math:`b` is the bitdepth, and :math:`l` is the lsb
cycle time.

.. math:: \text{BCM cycles} = r \sum_{i=0}^{b-1} \Bigg[ l\ 2^i \Bigg]

To calculate the time actually needed to refresh the display with use
the equation below where :math:`r` is the number of rows, :math:`b`
is the bitdepth, :math:`l` is the lsb cycle time, :math:`c`
is the number of columns, and :math:`H` is the overhead of the
display driver

.. math:: \text{display cycles} = r \sum_{i=0}^{b-1} \Bigg[ \text{max} \Big\{ l\ 2^i, c \Big\}  + H \Bigg]

To calculate light efficiency we simply divide the time needed for bcm
modulation by the time needed to refresh the display. This gives us the
equation shown below where :math:`r` is the number of rows,
:math:`b` is the bitdepth, :math:`l` is the lsb cycle time,
:math:`c` is the number of columns, and :math:`H` is the overhead
of the display driver.

.. math:: \text{light efficiency} = \frac{ \sum_{i=0}^{b-1} \Bigg[ l\ 2^i \Bigg]}{\sum_{i=0}^{b-1} \Bigg[ \text{max} \Big\{ l\ 2^i, c \Big\}  + H \Bigg]}

Summary
-------

To be able to calculate the refresh rate and light efficiency of a led
display, the equations are shown below where :math:`f` is clock
frequency of the display, :math:`r` is the number of rows, :math:`b`
is the bitdepth, :math:`l` is the lsb cycle time, :math:`c`
is the number of columns, and :math:`H` is the overhead of the
display driver

.. math:: \text{refresh rate} = \frac{f}{r \sum_{i=0}^{b-1} \Bigg[ \text{max} \Big\{ l\ 2^i, c \Big\}  + H \Bigg]}

.. math:: \text{light efficiency} = \frac{ \sum_{i=0}^{b-1} \Bigg[ l\ 2^i \Bigg]}{\sum_{i=0}^{b-1} \Bigg[ \text{max} \Big\{ l\ 2^i, c \Big\}  + H \Bigg]}

Extra
-----

To do the calculations using the equations above, I used the python code
shown below

.. code:: python

   n_rows = 32
   bitdepth = 8
   bcm_lsb_len = 20
   n_cols = 32
   freq = 25000000
   overhead = 3

   bcm_cycles = n_rows * sum(bcm_lsb_len * 2 ** i for i in range(0, bitdepth))
   display_cycles = n_rows * sum(max(bcm_lsb_len * 2 ** i, n_cols) + overhead for i in range(0, bitdepth))

   print(f"bcm cycles: {bcm_cycles}")
   print(f"display cycles: {display_cycles}")
   print(f"refresh rate:{freq / display_cycles : .2f}")
   print(f"light efficiency:{bcm_cycles / display_cycles : .4f}")

There is a closed form of the bcm cycles equation and it is shown below.
This will not prove that useful in when trying to figure out the true
refresh rate, but if you are doing computations to calculate a lot of
different refresh rates it can be helpful in speeding those up

.. math:: \text{BCM cycles} = r \sum_{i=0}^{b-1} \Bigg[ l\ 2^i \Bigg] = r l  (2^b-1)