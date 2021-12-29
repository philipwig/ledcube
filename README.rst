LED Panel Driver
================

This repository contains all the files needed to create an rgb led panel driver using a snickerdoodle Zynq board. This includes a Vivado project that contains a hardware led driver implemented in VHDL on the fpga portion of the Zynq. This is connected to the Arm cores on the Zynq using an AXI interface. The UIO interface is used to communicate with the hardware driver and create a memory mapped interface to write pixel data to. A C library provides an interface to writing animations and programs using this hardware.

.. install-start-do-not-remove
.. include:: docs/source/installation.rst
.. install-end-do-not-remove

Info
----

The project is split into the different folders in this repository.

::

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


The Makefile contains a lot of the commands needed to manage and build the project at different stages. Make sure to look at the command before running it as the paths might need to be modified for your system.
