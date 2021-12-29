


.PHONY: all
all: vivado-rebuild petalinux-build




# ******************************************************* Vivado Commands *******************************************************

VIVADO_PROJ_NAME = led_driver
VIVADO_PROJ_DIR = work
VIVADO_ARGS = -notrace -journal $(VIVADO_PROJ_DIR)/vivado.jou -log $(VIVADO_PROJ_DIR)/vivado.log

.PHONY: vivado-*

vivado-check:
	ifeq ($(shell which vivado >/dev/null 2>&1; echo $$?), 1)
	$(error The Vivado commands were not found. Make sure you have petalinux installed, then source the settings.sh file to activate the environment)
	endif

# Builds the project from tcl files. The project must not exist for this to succeed
vivado-build: vivado-check scripts/block-design.tcl scripts/build-project.tcl
	vivado -mode batch -source scripts/build-project.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR)
	# touch vivado-build # Maybe add the possibility to track the rebuilding of the project

# Cleans and then rebuilds the project from tcl files
vivado-rebuild: vivado-check scripts/block-design.tcl scripts/build-project.tcl vivado-remove vivado-build

# Open the vivado project gui
vivado-gui: vivado-check
	vivado -mode gui -source $(VIVADO_ARGS) $(VIVADO_PROJ_DIR)/$(VIVADO_PROJ_NAME).xpr

# Removes the project and all its files
vivado-remove:
	rm -rf $(VIVADO_PROJ_DIR)/*

# Cleans the vivado log and jou files
vivado-clean:
	rm -f $(VIVADO_PROJ_DIR)/*.jou $(VIVADO_PROJ_DIR)/*.log

# Generates the block diagram tcl script
vivado-bd: vivado-check
	vivado -mode batch -source scripts/write-block-design.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR)


# ****************************************************** Petalinux Commands *****************************************************

.PHONY: petalinux-*

petalinux-check:
	ifeq ($(shell which petalinux-build >/dev/null 2>&1; echo $$?), 1)
	$(error The petalinux commands were not found. Make sure you have petalinux installed, then source the settings.sh file to activate the environment)
	endif

petalinux-build: petalinux-check
	cd linux &&	petalinux-build
	cd linux &&	petalinux-package --boot --fsbl --fpga --u-boot --force

petalinux-clean: petalinux-check
	cd linux &&	petalinux-build -x mrproper

petalinux-hw: petalinux-check
	vivado -mode batch -source scripts/write-hw-platform.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR)
	cd linux &&	petalinux-config --get-hw-description hw-description

petalinux-copy:
	sudo cp linux/images/linux/BOOT.BIN /media/philip/BOOT/ && sudo cp linux/images/linux/image.ub /media/philip/BOOT/ && sudo cp linux/images/linux/system.dtb /media/philip/BOOT/
	sudo tar xvf linux/images/linux/rootfs.tar.gz -C /media/philip/rootfs/



# ******************************************************** sled Commands ********************************************************

ZYNQ_CC = arm-linux-gnueabihf-gcc
OUTMOD = zynq
SLED_ARGS = CC=$(ZYNQ_CC) DEFAULT_OUTMOD=$(OUTMOD) MARCH=

.PHONY: sled
sled: sled/sled-all

.PHONY: sled-clean
sled-clean: sled/sled-clean

sled-check:
	ifeq ($(shell which $(ZYNQ_CC) >/dev/null 2>&1; echo $$?), 1)
	$(error The '$(ZYNQ_CC)' command was not found. Make sure you have petalinux installed, then source the settings.sh file to activate the environment)
	endif


sled/sled-%: sled-check
	$(MAKE) $(subst sled/sled-,,$@) -C sled $(SLED_ARGS)

sled-copy:
	sudo cp sled/sled /media/philip/rootfs/home/root/sled
	sudo cp -r sled/modules /media/philip/rootfs/home/root/modules



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