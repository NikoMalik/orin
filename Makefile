# Default values
VERSION ?= v0.0.0-dev


OUTPUT_DIR ?= bin/
ARCH_LIST := amd64 arm64

OS_LIST := linux darwin windows

ifeq ($(OS),)
	OS := $(shell go env GOOS)
endif

ifeq ($(ARCH),)
	ARCH := $(shell go env GOARCH)
endif


linux: 
	@echo "Linux running"
	@./bin/orin-linux-amd64




all: build-all


# Build for all OS and ARCH combinations
build-all:
		@for os in $(OS_LIST); do \
        for arch in $(ARCH_LIST); do \
            $(MAKE) build OS=$$os ARCH=$$arch; \
        done; \
    done

build:
		@if [ -z "$(OS)" ]; then \
        echo "Error: OS must be specified."; \
        echo "Usage: make build OS=<os> [ARCH=<arch>]"; \
        exit 1; \
    fi
		@echo "Building for $(OS)-$(ARCH)"
		@mkdir -p $(OUTPUT_DIR)
		@GOOS=$(OS) GOARCH=$(ARCH) go build -o $(OUTPUT_DIR)/orin-$(OS)-$(ARCH)$(if $(filter windows,$(OS)),.exe) main.go

# Clean build artifacts
clean:
	@rm -rf $(OUTPUT_DIR)




help:
	@sh -c '\
		echo "Available targets:"; \
		echo "  make              : Build for all supported OS and ARCH combinations"; \
		echo "  make build OS=<os> [ARCH=<arch>] : Build for a specific OS and ARCH"; \
		echo "  make clean        : Remove build artifacts"; \
		echo ""; \
		echo "Supported OS  : $(OS_LIST)"; \
		echo "Supported ARCH: $(ARCH_LIST)"; \
		echo ""; \
		echo "Environment variables:"; \
		echo "  VERSION           : Set the version (default: v0.0.0-dev)"; \
		echo "  OUTPUT_DIR        : Override the output directory"; \
		echo ""; \
		echo "Note: If ARCH is not specified, it will be inferred from the current machine."'

.PHONY: all build-all build clean help
