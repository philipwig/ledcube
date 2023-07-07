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

VIVADO_PROJ_NAME = led_panel_driver
VIVADO_PROJ_DIR = $(abspath hdl/work)

VIVADO_IP_DIR = $(abspath hdl/src/led_driver)
VIVADO_CONSTRAINTS_DIR = $(abspath hdl/src/constraints)
VIVDAO_SCRIPTS_DIR = $(abspath hdl/scripts)
VIVADO_HW_DIR = $(abspath hdl/hw-description)

VIVADO_ARGS = -notrace -journal $(VIVADO_PROJ_DIR)/vivado.jou -log $(VIVADO_PROJ_DIR)/vivado.log

# .PHONY: vivado-*

# Builds the project from tcl files. The project must not exist for this to succeed
vivado-build: $(VIVDAO_SCRIPTS_DIR)/block_design.tcl $(VIVDAO_SCRIPTS_DIR)/build_project.tcl
	mkdir -p $(VIVADO_PROJ_DIR)
	vivado -mode batch -source $(VIVDAO_SCRIPTS_DIR)/build_project.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR) $(VIVADO_IP_DIR) $(VIVADO_CONSTRAINTS_DIR) $(VIVDAO_SCRIPTS_DIR)

# Cleans and then rebuilds the project from tcl files
vivado-rebuild: vivado-remove vivado-build vivado-hw

# Open the vivado project gui
.PHONY: vivado-gui
vivado-gui:
	vivado -mode gui -source $(VIVADO_ARGS) $(VIVADO_PROJ_DIR)/$(VIVADO_PROJ_NAME).xpr

# Generates the block diagram tcl script
.PHONY: vivado-bd
vivado-bd:
	vivado -mode batch -source $(VIVDAO_SCRIPTS_DIR)/write_block_design.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR) $(VIVDAO_SCRIPTS_DIR)

# Generates hardware platform xsa file
.PHONY: vivado-hw
vivado-hw:
	vivado -mode batch -source $(VIVDAO_SCRIPTS_DIR)/write_hw_platform.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR) $(VIVADO_HW_DIR)

# Removes the project and all its files
.PHONY: vivado-remove
vivado-remove:
	rm -rf $(VIVADO_PROJ_DIR)

# Cleans the vivado log and jou files
.PHONY: vivado-clean
vivado-clean:
	rm -f $(VIVADO_PROJ_DIR)/*.jou $(VIVADO_PROJ_DIR)/*.log




vivado-non-project: $(VIVDAO_SCRIPTS_DIR)/block_design.tcl $(VIVDAO_SCRIPTS_DIR)/build_non_project.tcl
	mkdir -p $(VIVADO_PROJ_DIR)/non_project
	vivado -mode batch -source $(VIVDAO_SCRIPTS_DIR)/build_non_project.tcl $(VIVADO_ARGS) -tclargs $(VIVADO_PROJ_NAME) $(VIVADO_PROJ_DIR)/non_project $(VIVADO_IP_DIR) $(VIVADO_CONSTRAINTS_DIR) $(VIVDAO_SCRIPTS_DIR)


# ****************************************************** Petalinux Commands *****************************************************

PETALINUX_DIR = linux/linux-clean

.PHONY: petalinux-*

petalinux-build: 
	cd $(PETALINUX_DIR); petalinux-build
#   cd $(PETALINUX_DIR) &&	petalinux-package --boot --fsbl --fpga --u-boot --force

petalinux-clean:
	cd $(PETALINUX_DIR); petalinux-build -x mrproper

petalinux-hw: vivado-hw
	cd $(PETALINUX_DIR); petalinux-config --get-hw-description $(VIVADO_HW_DIR)/$(VIVADO_PROJ_NAME).xsa --silentconfig

petalinux-copy:
	sudo cp linux/images/linux/BOOT.BIN /media/philip/BOOT/ && sudo cp linux/images/linux/image.ub /media/philip/BOOT/ && sudo cp linux/images/linux/system.dtb /media/philip/BOOT/
	sudo tar xvf linux/images/linux/rootfs.tar.gz -C /media/philip/rootfs/

petalinux-jtag:
	cd $(PETALINUX_DIR); petalinux-boot --jtag --kernel

# ******************************************************** sled Commands ********************************************************

ZYNQ_CC = arm-linux-gnueabihf-gcc
OUTMOD = dummy
SLED_ARGS = CC=$(ZYNQ_CC) DEFAULT_OUTMOD=$(OUTMOD)

.PHONY: sled
sled:
	cd linux/linux-clean/project-spec/meta-user/recipes-apps/sled/files; $(MAKE) -j12 $(SLED_ARGS)

.PHONY: sled-copy
sled-copy: sled
	cd linux/linux-clean/project-spec/meta-user/recipes-apps/sled/files; scp -r modules sled sledconf ledcube@10.42.0.251:~

# .PHONY: sled-clean
# sled-clean: sled/sled-clean

# sled/sled-%:
# 	$(MAKE) $(subst sled/sled-,,$@) -C sled $(SLED_ARGS)

# sled-copy:
# 	sudo cp sled/sled /media/philip/rootfs/home/root/sled
# 	sudo cp -r sled/modules /media/philip/rootfs/home/root/modules



# ******************************************************** panel ctrl Commands ********************************************************

ZYNQ_CC = arm-linux-gnueabihf-gcc
PANEL_CTRL_ARGS = CC=$(ZYNQ_CC)

.PHONY: panel-ctrl
panel-ctrl:
	cd linux/linux-clean/project-spec/meta-user/recipes-apps/panel-ctrl/files; $(MAKE) $(PANEL_CTRL_ARGS)

.PHONY: panel-ctrl-copy
panel-ctrl-copy: panel-ctrl
	cd linux/linux-clean/project-spec/meta-user/recipes-apps/panel-ctrl/files; scp panel-ctrl ledcube@10.42.0.251:.
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
.PHONY: gtkterm
gtkterm:
	gtkterm -p /dev/ttyACM0 -s 115200 &

