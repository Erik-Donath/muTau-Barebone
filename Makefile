# muTau-PlatformIO/Makefile

BASE_DIR      ?= base
BOARD_NAME    ?= tang_nano_9k
BOARD_ARGS    ?= NO_EXTERNAL_RAM=1
LITEX_BUILD   := $(BASE_DIR)/build/$(BOARD_NAME)
LITEX_GEN_DIR := $(LITEX_BUILD)/software/include/generated

BBUILD_DIR    := build
BINARY_NAME   := barebone
BIN_PATH      := $(BBUILD_DIR)/$(BINARY_NAME).bin

IMAGE_NAME    ?= mutau-platformio

.PHONY: all
all: build

# Ensure LiteX build exists; if not, run make build in base
.PHONY: litex-build
litex-build:
	@if [ ! -f "$(LITEX_GEN_DIR)/variables.mak" ]; then \
		echo ">>> LiteX artifacts missing, running 'make build BOARD=$(BOARD_NAME) $(BOARD_ARGS)' in $(BASE_DIR)"; \
		$(MAKE) -C $(BASE_DIR) build BOARD=$(BOARD_NAME) $(BOARD_ARGS); \
	else \
		echo ">>> LiteX artifacts found in $(LITEX_GEN_DIR)"; \
	fi

.PHONY: docker-build
docker-build:
	docker build -t $(IMAGE_NAME) .

.PHONY: build
build: docker-build litex-build
	@mkdir -p $(BBUILD_DIR)
	docker run --rm \
		-v "$(PWD):/work" \
		-w "/work" \
		$(IMAGE_NAME) \
		bash -lc 'cmake -S . -B $(BBUILD_DIR) -G Ninja \
			-DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-riscv.cmake \
			-DLITEX_BUILD_DIR=$(LITEX_BUILD) && \
			cmake --build $(BBUILD_DIR)'

.PHONY: load
load: litex-build
	$(MAKE) -C $(BASE_DIR) $(BOARD_ARGS) load

.PHONY: upload
upload: build
	$(MAKE) -C $(BASE_DIR) upload $(BOARD_ARGS) KERNEL=$(PWD)/$(BIN_PATH)

.PHONY: shell
shell: docker-build
	docker run --rm -it \
		-v "$(PWD):/work" \
		-w "/work" \
		$(IMAGE_NAME) \
		bash

.PHONY: clean
clean:
	rm -rf $(BBUILD_DIR)
	rm -rf $(BASE_DIR)/build
