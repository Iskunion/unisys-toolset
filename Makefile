export ISKAM = /home/litrehinn/Documents/Programs/unisys-toolset/iskam-unisys-emu/iskam-unisys
export ISKEMU = /home/litrehinn/Documents/Programs/unisys-toolset/iskam-unisys-emu/iskemu
AM_APPS ?= /home/litrehinn/Documents/Programs/unisys-toolset/iskam-unisys-emu/am-apps

unisys-soc:
	$(MAKE) -C unisys-soc sim MEM_DIR=$(ISKAM)/build/memory

# TEST-NAME
# AM-NAME

APP_NAME ?= dummy
TEST_NAME ?= cpu-tests
export ALL ?= bit

am-clean:
	$(MAKE) -C $(ISKAM) clean

am-sweep:
	$(MAKE) -C $(ISKAM) clean-all

app-image:
	$(MAKE) -C $(AM_APPS)/$(APP_NAME) image

app-clean: am-clean
	$(MAKE) -C $(AM_APPS)/$(APP_NAME) clean

test-image:
	$(MAKE) -C $(AM_APPS)/tests/$(TEST_NAME) image

app-sim: app-image unisys-soc
	@mkdir -p build
	@cp unisys-soc/build/wave.vcd build
	@cp build/wave.vcd ~/Share/

.PHONY: app-image app-clean test-image am-clean unisys-soc app-sim