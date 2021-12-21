/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"

#define CONTROL_BASE_ADDR 0x43C00000

#define N_ROWS_REGISTER (CONTROL_BASE_ADDR + 4)
#define N_COLS_REGISTER (CONTROL_BASE_ADDR + 8)
#define BITDEPTH_REGISTER (CONTROL_BASE_ADDR + 12)
#define LSB_LENGTH_REGISTER (CONTROL_BASE_ADDR + 16)

#define PATTERN_BASE_ADDR 0x40000000

int main()
{
    init_platform();

    print("Hello World\n\r");
    print("Successfully ran Hello World application");

    Xil_Out32(CONTROL_BASE_ADDR, 0x00000003); // Need to set to a hex 3 to enable the led_panel_driver
    Xil_Out32(N_ROWS_REGISTER, 64); // Set to 64 for a 64x64 1:32 panel. It will output 2xRGB data for 32 rows
    Xil_Out32(N_COLS_REGISTER, 64);
	Xil_Out32(LSB_LENGTH_REGISTER, 40);

    while(1) {
    	Xil_Out32(PATTERN_BASE_ADDR, 0xFFFFFFFF);

    	for (int i = 0; i < 10000; i++);

    	Xil_Out32(PATTERN_BASE_ADDR, 0xFFFFFF00);

    	for (int i = 0; i < 10000; i++);

    }

    cleanup_platform();
    return 0;
}
