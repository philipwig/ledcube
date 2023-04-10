

INCLUDE := ../src/led_driver
BIN := ./bin
TB := ./tb
WAVES := ./waves


FLAGS = -Wall -Winfloop

# Create all necessary directories
DIRS := $(INCLUDE) $(BIN) $(TB) $(WAVES)
$(info $(shell mkdir -p $(DIRS)))

# .PHONY: default
# default: clean waveform.vcd


# .PHONY: waves
# waves: waveform.vcd
# 	@echo
# 	@echo "### WAVES ###"
# 	gtkwave waveform.vcd


.PHONY: tb_framebuffer
tb_framebuffer: $(WAVES)/tb_framebuffer


.PHONY: tb_led_driver
tb_led_driver: $(WAVES)/tb_led_driver


# clean:
# 	rm -f $(BIN)/*
# 	rm -f $(WAVES)/*

$(BIN)/%.vvp: $(TB)/%.v $(INCLUDE)/*.v
	iverilog $< $(FLAGS) -D'DUMP_FILE_NAME="$(WAVES)/$(patsubst %.vvp,%.vcd,$(@F))"' -o $@ -I $(INCLUDE) 

$(WAVES)/%: $(BIN)/%.vvp
	vvp $<
