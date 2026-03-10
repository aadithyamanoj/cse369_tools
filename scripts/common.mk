SHELL := /usr/bin/env bash

ifndef MODULE
$(error MODULE is not set. In your lab Makefile, add: MODULE := your_module_name)
endif

REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
TOOLS_DIR := $(REPO_ROOT)/tools/icarus
IVERILOG := $(TOOLS_DIR)/bin/iverilog
VVP := $(TOOLS_DIR)/bin/vvp


RTL_DIR ?= src
TB_DIR ?= tb
WRAPPER_SRC := $(REPO_ROOT)/scripts/tb_wrapper.sv
BUILD_DIR ?= build
SIM_OUT ?= $(BUILD_DIR)/simv
TB_TOP := $(MODULE)_tb
VCD_FILE := \"$(BUILD_DIR)/$(MODULE).vcd\"
IVERILOG_FLAGS ?= -g2012 \
				  -DTOP_TB=$(TB_TOP) \
				  -DVCD_FILE=$(VCD_FILE) \
				  -Wall \
				  -pfileline=1 \
				  -s tb_wrapper\

RTL_SRCS := $(wildcard $(RTL_DIR)/*.v) $(wildcard $(RTL_DIR)/*.sv)
TB_SRCS := $(wildcard $(TB_DIR)/*.v) $(wildcard $(TB_DIR)/*.sv)

.PHONY: check compile run test clean

check:
	@test -x "$(IVERILOG)" || (echo "Missing local iverilog. Run setup from repo root."; exit 1)
	@test -x "$(VVP)" || (echo "Missing local vvp. Run setup from repo root."; exit 1)

compile: check
	@mkdir -p $(BUILD_DIR)
	$(IVERILOG) $(IVERILOG_FLAGS) -o $(SIM_OUT) $(RTL_SRCS) $(TB_SRCS) $(WRAPPER_SRC)

run: compile
	mkdir -p $(BUILD_DIR)
	$(VVP) $(SIM_OUT)


test: run

clean:
	rm -rf $(BUILD_DIR)

