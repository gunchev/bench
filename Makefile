TOP := $(shell dirname "$(abspath $(lastword $(MAKEFILE_LIST)))")
CMAKE_BUILD_PARALLEL_LEVEL := $(shell (nproc; echo 128) | sort -n | head -n 1)
CMAKE := cmake
CCMAKE := ccmake


.PHONY: help
help:
	@echo
	@echo "| Help"
	@echo "+======"
	@echo
	@echo "Available targets:"
	@echo  "    debug:              debug build"
	@echo  "    debugc:             debug build with clang"
	@echo  "    debugcov:           debug build with coverage"
	@echo  "    debugcovc:          debug build with coverage with clang"
	@echo  "    release:            release build"
	@echo  "    releasec:           release build with clang"
	@echo  "    relwithdebinfo:     release build with debug info"
	@echo  "    relwithdebinfoc:    release build with debug info and clang"
	@echo  "    minsizerel:         minimum size release build (-Os)"
	@echo  "    minsizerelc:        minimum size release build (-Os) and clang"
	@echo
	@echo  "    distclean:          remove all build files"
	@echo


.PHONY: build
build:
	( test -d "$(BUILD_DIR)" && cd "$(BUILD_DIR)" && $(MAKE) ) || ( mkdir -p "$(BUILD_DIR)" && cd "$(BUILD_DIR)" && $(CMAKE) -D CMAKE_BUILD_TYPE="$(BUILD_TYPE)" "$(TOP)" && $(MAKE) )

.PHONY: buildc
buildc:
	( test -d "$(BUILD_DIR)" && cd "$(BUILD_DIR)" && $(MAKE) ) || ( mkdir -p "$(BUILD_DIR)" && cd "$(BUILD_DIR)" && CC=clang CXX=clang++ $(CMAKE) -D CMAKE_BUILD_TYPE="$(BUILD_TYPE)" "$(TOP)" && $(MAKE) )

.PHONY: debug
debug: BUILD_DIR=$(TOP)/build/debug
debug: BUILD_TYPE=Debug
debug: build

.PHONY: debugc
debugc: BUILD_DIR=$(TOP)/build/debugc
debugc: BUILD_TYPE=Debug
debugc: buildc

.PHONY: debugcov
debugcov: BUILD_DIR=$(TOP)/build/debugcov
debugcov: BUILD_TYPE=DebugCov
debugcov: build

.PHONY: debugcovc
debugcovc: BUILD_DIR=$(TOP)/build/debugcovc
debugcovc: BUILD_TYPE=DebugCov
debugcovc: buildc

.PHONY: release
release: BUILD_DIR=$(TOP)/build/release
release: BUILD_TYPE=Release
release: build

.PHONY: releasec
releasec: BUILD_DIR=$(TOP)/build/releasec
releasec: BUILD_TYPE=Release
releasec: buildc

.PHONY: relwithdebinfo
relwithdebinfo: BUILD_DIR=$(TOP)/build/relwithdebinfo
relwithdebinfo: BUILD_TYPE=RelWithDebInfo
relwithdebinfo: build

.PHONY: relwithdebinfoc
relwithdebinfoc: BUILD_DIR=$(TOP)/build/relwithdebinfoc
relwithdebinfoc: BUILD_TYPE=RelWithDebInfo
relwithdebinfoc: buildc

.PHONY: minsizerel
minsizerel: BUILD_DIR=$(TOP)/build/minsizerel
minsizerel: BUILD_TYPE=MinSizeRel
minsizerel: build

.PHONY: minsizerelc
minsizerelc: BUILD_DIR=$(TOP)/build/minsizerelc
minsizerelc: BUILD_TYPE=MinSizeRel
minsizerelc: buildc


.PHONY: all
all:
	make debug
	make debugcov
	make release
	make relwithdebinfo
	make minsizerel
	make debugc
	make debugcovc
	make releasec
	make relwithdebinfoc
	make minsizerelc


distclean:
	-rm -rf "$(TOP)"/build/
.PHONY: distclean
dc: distclean
