# LED Panel Driver

This repository contains all the files needed to create an rgb led panel driver using a snickerdoodle Zynq board. This includes a vivado project that contains a hardware led driver implemented in VHDL on the fpga portion of the Zynq. This is connected to the Arm cores on the Zynq using an AXI interface. The UIO interface is used to communicate with the hardware driver and create a memory mapped interface to write pixel data to. A C library provides an interface to writing animations and programs using this hardware.

## Installation

### Requirements

To be able to compile and run all of the different parts there is quite a hefty list of software that is needed.

All of the makefiles and scripts were created on linux so it is highly recommended. Ubuntu 20.04 was used. It might be possible to build all of this using wsl on windows but still has to be tried out.

### Required Software

1. Xilinx Vivado 2021.1
2. Xilinx PetaLinux 2021.1
3. Make
4. A serial terminal (I used GTKTerm)
5. All the other stuff I am forgetting

### Required for Docs

1. A recent python of some sort
2. Sphinx
3. Doxygen
4. Breathe
5. sphinx_rtd_theme

### Cloning

To clone the project run the following command in the directory where you want the project to be cloned to.

```shell
    git clone --recursive https://github.com/philipwig/ledcube.git
```

Then change into the directory to start working.

```shell
    cd ledcube
```

### Building

To build everything in the project you will need to make sure the Xilinx tools are avaliable on the commandline. I've written a simple shell script to load the required settings

```shell
#!/bin/bash
# From vivado and vitis
source /home/philip/tools/Xilinx/Vivado/2021.1/settings64.sh

# For petalinux
source /home/philip/tools/Xilinx/PetaLinux/settings.sh
```

You will have to change the relevant paths to the settings.sh files. Then all you have to do is run the shell script. I placed the script in my bin folder.
Now I just call xilinx-tools to load Vivado and PetaLinux.

```console
philip@PHILIP-DESKTOP:~$ xilinx-tools
PetaLinux environment set to '/home/philip/tools/Xilinx/PetaLinux'
WARNING: /bin/sh is not bash! 
bash is PetaLinux recommended shell. Please set your default shell to bash.
WARNING: This is not a supported OS
INFO: Checking free disk space
INFO: Checking installed tools
INFO: Checking installed development libraries
INFO: Checking network and other services
WARNING: No tftp server found - please refer to "UG1144 2021.1 PetaLinux Tools Documentation Reference Guide" for its impact and solution
```

Once this is done all you should have to to is run make to build everything.

```shell
make all
```

## Info

The project is split into the different folders in this repository.

```shell
    .
    ├── docs                # Documentation files. This is where the sphinx and doxygen docs are generated
    ├── linux               # PetaLinux files. Has everything needed to build a linux kernel for the snickerdoodle board
    ├── old-stuff           # Old files that have nowhere else to go
    ├── scripts             # Vivado and other scripts that are used in the makefile
    ├── sled                # The source for the sled project. This is a git submodule of my fork of the sled repository
    ├── src                 # All of the code source files for the various parts of this project
    ├── work                # Directory where the Vivado project is created
    ├── .gitignore
    ├── .gitmodules
    ├── Makefile
    └── README.md.
```

The Makefile contains a lot of the commands needed to manage and build the project at different stages. Make sure to look at the command before running it as the paths might need to be modified for your system.
