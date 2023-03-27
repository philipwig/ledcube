# Makefile for the ledcube repository. Hopefully it all works
# Most common problem is not sourcing the Vivado and PetaLinux commands commands
# See README for instructions on how to setup convenient script to load these


.PHONY: all
all: vivado-rebuild petalinux-build





SRC = ../src/
TESTBENCHES = tb_framebuffer.v tb_led_driver.v

FLAGS = -Wall -Winfloop

.PHONY: default
default: clean waveform.vcd


.PHONY: waves
waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd

waveform.vcd: tb
	@echo
	@echo "### SIMULATING ###"
	vvp tb

tb: $(TESTBENCHES) $(SRC)*.v
	@echo
	@echo "### BUILDING SIM ###"
	iverilog $(FLAGS) -o $@ -I $(SRC) $(TESTBENCH)


clean:
	rm tb
	rm waveform.vcd


# ******************************************************* Vivado Commands *******************************************************

# VIVADO_PROJ_NAME = led_driver
# VIVADO_PROJ_DIR = work
# VIVADO_ARGS = -notrace -journal $(VIVADO_PROJ_DIR)/vivado.jou -log $(VIVADO_PROJ_DIR)/vivado.log

# .PHONY: vivado-*

# # Builds the project from tcl files. The project must not exist for this to succeed
# vivado-build: scripts/block-design.tcl scripts/build-project.tcl
# 	vivado -mode batch -source scripts/build-project.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR)
# 	# touch vivado-build # Maybe add the possibility to track the rebuilding of the project

# # Cleans and then rebuilds the project from tcl files
# vivado-rebuild: scripts/block-design.tcl scripts/build-project.tcl vivado-remove vivado-build

# # Open the vivado project gui
# vivado-gui:
# 	vivado -mode gui -source $(VIVADO_ARGS) $(VIVADO_PROJ_DIR)/$(VIVADO_PROJ_NAME).xpr

# # Removes the project and all its files
# vivado-remove:
# 	rm -rf $(VIVADO_PROJ_DIR)/*

# # Cleans the vivado log and jou files
# vivado-clean:
# 	rm -f $(VIVADO_PROJ_DIR)/*.jou $(VIVADO_PROJ_DIR)/*.log

# # Generates the block diagram tcl script
# vivado-bd:
# 	vivado -mode batch -source scripts/write-block-design.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR)


# ****************************************************** Petalinux Commands *****************************************************

# .PHONY: petalinux-*


# petalinux-build:
# 	cd linux &&	petalinux-build
# 	cd linux &&	petalinux-package --boot --fsbl --fpga --u-boot --force

# petalinux-clean:
# 	cd linux &&	petalinux-build -x mrproper

# petalinux-hw:
# 	vivado -mode batch -source scripts/write-hw-platform.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR)
# 	cd linux &&	petalinux-config --get-hw-description hw-description

# petalinux-copy:
# 	sudo cp linux/images/linux/BOOT.BIN /media/philip/BOOT/ && sudo cp linux/images/linux/image.ub /media/philip/BOOT/ && sudo cp linux/images/linux/system.dtb /media/philip/BOOT/
# 	sudo tar xvf linux/images/linux/rootfs.tar.gz -C /media/philip/rootfs/



# ******************************************************** sled Commands ********************************************************

# ZYNQ_CC = arm-linux-gnueabihf-gcc
# OUTMOD = zynq
# SLED_ARGS = CC=$(ZYNQ_CC) DEFAULT_OUTMOD=$(OUTMOD) MARCH=

# .PHONY: sled
# sled: sled/sled-all

# .PHONY: sled-clean
# sled-clean: sled/sled-clean

# sled/sled-%:
# 	$(MAKE) $(subst sled/sled-,,$@) -C sled $(SLED_ARGS)

# sled-copy:
# 	sudo cp sled/sled /media/philip/rootfs/home/root/sled
# 	sudo cp -r sled/modules /media/philip/rootfs/home/root/modules



# ******************************************************** Docs Commands ********************************************************

# Docs targets
# Use "make docs" to make the default docs
# Use "make docs-<option>" to pass options to the docs makefile
.PHONY: docs
docs: docs/docs-default

.PHONY: docs-clean
docs-clean: docs/docs-clean

docs/docs-%:
	$(MAKE) $(subst docs/docs-,,$@) -C docs



# ******************************************************** Other Commands *******************************************************
gtkterm:
	sudo gtkterm -c snickerdoodle