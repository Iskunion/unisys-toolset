export ISKAM = $(shell realpath ./iskam-unisys-emu/iskam-unisys)
export ISKEMU = $(shell realpath ./iskam-unisys-emu/iskemu)
AM_APPS ?= $(shell realpath ./iskam-unisys-emu/am-apps)

LOCAL = build
REMOTE = $(shell realpath ~/Share/unisys)

$(shell mkdir -p ~/Share)
$(shell mkdir -p $(LOCAL))
$(shell mkdir -p $(REMOTE))

unisys-sim:
	$(MAKE) -C unisys-soc sim MEM_DIR=$(ISKAM)/build/memory GMEM_DIR=$(REMOTE)/memory

unisys-pre:
	$(MAKE) -C unisys-soc pre-compile MEM_DIR=Z:/unisys/memory GMEM_DIR=Z:/unisys/memory

# TEST-NAME
# AM-NAME

APP_NAME ?= iskterm
TEST_NAME ?= am-tests
export ALL ?= bit
export mainargs ?= v

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

test-clean: am-clean
	$(MAKE) -C $(AM_APPS)/tests/$(TEST_NAME) image

app-sim: app-image unisys-sim
	@mkdir -p $(LOCAL)/wave
	@mkdir -p $(REMOTE)/wave
	@cp unisys-soc/build/wave.vcd $(LOCAL)/wave
	@cp unisys-soc/build/wave.vcd $(REMOTE)/wave

test-sim: test-image unisys-sim
	@mkdir -p $(LOCAL)/wave
	@mkdir -p $(REMOTE)/wave
	@cp unisys-soc/build/wave.vcd $(LOCAL)/wave
	@cp unisys-soc/build/wave.vcd $(REMOTE)/wave

app-pre: app-image unisys-pre
	@mkdir -p $(LOCAL)/memory
	@mkdir -p $(REMOTE)/memory
	@mkdir -p $(LOCAL)/rtl
	@mkdir -p $(REMOTE)/rtl
	@cp $(ISKAM)/build/memory/* $(LOCAL)/memory
	@cp $(ISKAM)/build/memory/* $(REMOTE)/memory
	@cp unisys-soc/build/unisys_pre.sv $(LOCAL)/rtl
	@cp unisys-soc/build/unisys_pre.sv $(REMOTE)/rtl

test-pre: test-image unisys-pre
	@mkdir -p $(LOCAL)/memory
	@mkdir -p $(REMOTE)/memory
	@mkdir -p $(LOCAL)/rtl
	@mkdir -p $(REMOTE)/rtl
	@cp $(ISKAM)/build/memory/* $(LOCAL)/memory
	@cp $(ISKAM)/build/memory/* $(REMOTE)/memory
	@cp unisys-soc/build/unisys_pre.sv $(LOCAL)/rtl
	@cp unisys-soc/build/unisys_pre.sv $(REMOTE)/rtl

iskemu-app:
	$(MAKE) -C $(AM_APPS)/$(APP_NAME) run

iskemu-test:
	$(MAKE) -C $(AM_APPS)/tests/$(TEST_NAME) run

clean:
	-@rm -r $(LOCAL)
	-@rm -r $(REMOTE)

.PHONY: app-image app-clean test-image am-clean unisys-sim app-sim test-clean