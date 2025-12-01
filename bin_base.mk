ifeq ($(LOCAL_BUILD_PATH),)
	LOCAL_BUILD_PATH := $(CURDIR)
endif

ifndef SRCS
	SRCS = \
		$(wildcard *.cpp) \
		$(wildcard **/*.cpp) \
		$(wildcard **/**/*.cpp) \
		$(wildcard **/**/**/*.cpp)
endif

ifdef IS_LIB
	OUTPUT_DIR ?= $(LOCAL_LIB_PATH)

else
	OUTPUT_DIR ?= $(LOCAL_BIN_PATH)

	ifeq ($(OUTPUT_DIR),$(LOCAL_BIN_PATH))
		OUTPUT_DIR_LOCAL := 1
	endif

	ifdef IS_TEST
		ifdef OUTPUT_DIR_LOCAL
			OUTPUT_DIR := $(OUTPUT_DIR)/tests
		endif
	endif

endif

#OUTPUT_DIR ?= $(CURDIR)/..
