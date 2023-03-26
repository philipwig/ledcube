

# TESTBENCH = tb_framebuffer.v
SRC = ../src

TESTBENCH = tb_led_driver.v
SRC = ../src/led_driver.v

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

tb: $(TESTBENCH) $(SRC)
	@echo
	@echo "### BUILDING SIM ###"
	iverilog $(FLAGS) -o $@ -I $(SRC) $(TESTBENCH)


clean:
	rm tb
	rm waveform.vcd
