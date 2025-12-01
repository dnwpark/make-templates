# make-templates

Templates to build c++ using make.

Source code should be organized as:
```
ROOT/
├─ _make/  <- this repo as a submodule
├─ project_a/
|  ├─ src/
|  |  ├─ app/
|  |  |  ├─ makefile
|  |  |  ├─ main.cpp
|  |  |  ├─ ...
|  |  ├─ utils/
|  |  |  ├─ makefile
|  |  |  ├─ ...
|  |  ├─ _dir.mk
|  ├─ _dir.mk
|  ├─ _local.mk
├─ ...
├─ _dir.mk
├─ _root.mk
├─ makefile
```

Code is organized into "projects" which each have a `_local.mk` for configuration.

The `_root.mk` file provides global configuration. One project can be set as the "common" project, allowing binaries to be shared across projects.

All non-build directories (ie. without a `makefile` for an executable or library), should have a symlink to `_dir.mk`. This allows make to traverse the directories.


## Usage

In the root directory:
```bash
make all
make debug
make test
make test_d # debug test
make clean
```


## Setup

Add the make files as a submodule:
```bash
git submodule add https://github.com/dnwpark/make-templates.git _make
```

Add a `_root.mk` config file:
```make
# Compiler
ifeq ($(OS),Windows_NT)
    CC_COMMON = x86_64-w64-mingw32-g++.exe
else
    CC_COMMON = g++
endif

# Compiler flags
CFLAGS_COMMON = -Wall -Wextra -Werror -std=gnu++23
CFLAGS_ALL_COMMON = -O3 -s -DNDEBUG
CFLAGS_DEBUG_COMMON = -O0 -g

# Libraries common to all projects
COMMON_LIB_LIB_PATH = $(ROOT_DIR)/_common/_lib
COMMON_LIB_SRC_PATH = $(ROOT_DIR)/_common/src

# 3rd party libraries
3RD_PARTY_PATH = $(ROOT_DIR)/_common/_3rd_party
```

Add a root `makefile`:
```make
include ./_dir.mk
```

Add symlinks to `_make/_dir.mk` in all non-build directories.

Add a `_local.mk` which to define build directories, as well as any other project specific local configuration:
```make
THIS_FILE := $(lastword $(MAKEFILE_LIST))
THIS_DIR := $(dir $(THIS_FILE))

LOCAL_SRC_PATH := $(THIS_DIR)/src
LOCAL_BUILD_PATH := $(THIS_DIR)/_build
LOCAL_LIB_PATH := $(THIS_DIR)/_lib
LOCAL_BIN_PATH := $(THIS_DIR)/_bin
```

Add makefiles to executable projects:
```make
include ../_dir.mk

# Compiler and flags
CC = $(CC_COMMON)
CFLAGS = $(CFLAGS_COMMON)

# Executable name
EXE_NAME = app

# Common and local libraries to link
COMMON_LIB_NAMES = my_util
LOCAL_LIB_NAMES = local_utils

# Other libraries to link
ifeq ($(OS),Windows_NT)
LFLAGS = -lmingw32 -luuid
else
LFLAGS = -luuid
endif

# Include and link paths
INCLUDES = -I$(LOCAL_SRC_PATH) -I$(COMMON_LIB_SRC_PATH) -I$(3RD_PARTY_PATH)
LIB_PATHS = -L$(LOCAL_LIB_PATH) -L$(COMMON_LIB_LIB_PATH)

# Build as executable
include $(ROOT_DIR)/_make/exe.mk
```

Add makefiles to libraries:
```make
include ../_dir.mk

# Compiler and flags
CC = $(CC_COMMON)
CFLAGS = $(CFLAGS_COMMON)

# Library name
LIB_NAME = libtranslation1

# Include paths
INCLUDES = -I$(LOCAL_SRC_PATH) -I$(COMMON_LIB_SRC_PATH) -I$(3RD_PARTY_PATH)

# Build as library
include $(ROOT_DIR)/_make/lib.mk
```
