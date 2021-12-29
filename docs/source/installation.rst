Installation
------------

Requirements
~~~~~~~~~~~~

To be able to compile and run all of the different parts there is quite a hefty list of software that is needed.

All of the makefiles and scripts were created on linux so it is highly recommended. Ubuntu 20.04 was used. It might be possible to build all of this using wsl on windows but still has to be tried out.

Required Software
~~~~~~~~~~~~~~~~~

1. Xilinx Vivado 2021.1
2. Xilinx PetaLinux 2021.1
3. Make
4. A serial terminal (I used GTKTerm)
5. All the other stuff I am forgetting

Required for Docs
~~~~~~~~~~~~~~~~~

1. A recent python of some sort
2. Sphinx
3. Doxygen
4. Breathe
5. sphinx_rtd_theme

Cloning
~~~~~~~

To clone the project run the following command in the directory where you want the project to be cloned to.

.. code-block:: shell

    git clone --recursive https://github.com/philipwig/ledcube.git


Then change into the directory to start working.

.. code-block:: shell

    cd ledcube


Building
~~~~~~~~

To build everything in the project you will need to make sure the Xilinx tools are available on the command line.
I've written a simple shell script to load the required settings shell files that are included with Vivado and PetaLinux.
You will have to change the paths to match where Vivado and PetaLinux are installed on your computer.

.. code-block:: shell

    #!/bin/bash
    # From Vivado and Vitis
    source /home/philip/tools/Xilinx/Vivado/2021.1/settings64.sh

    # For PetaLinux
    source /home/philip/tools/Xilinx/PetaLinux/settings.sh


You will have to change the relevant paths to the settings.sh files. Then all you have to do is source the shell script. I placed the script in my bin folder and added an alias to my .bashrc

.. code-block:: shell

    alias xilinx-tools="source /home/philip/bin/xilinx-tools.sh"


Now I just call xilinx-tools to load Vivado and PetaLinux.

.. code-block:: sh

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


Once this is done all you should have to to is run make to build everything.

.. code-block:: shell

    make all

