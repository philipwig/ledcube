/*
* Copyright (C) 2013 - 2016  Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in this
* Software without prior written authorization from Xilinx.
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
  
// Make the SDK console work in the debugger
#define printf(...) \
 fprintf(stdout, __VA_ARGS__); \
 fflush(stdout);
  
typedef long int u32;
  
int main()
{
   unsigned int bram_size = 0xFFFF;
   off_t bram_pbase = 0x40000000; // physical base address 0xF000
   u32 *bram32_vptr;
   int fd;
  
   // Map the BRAM physical address into user space getting a virtual address for it
   if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) != -1) {
  
      bram32_vptr = (u32 *)mmap(NULL, bram_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, bram_pbase);
  
      // Write to the memory that was mapped, use devmem from the command line of Linux to verify it worked
      // it could be read back here also
  
      bram32_vptr[0] = 0xDEADBEEFFACEB00C;
      close(fd);
   }
 }