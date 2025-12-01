ifeq ($(ROOT_DIR),)
	ROOT_DIR := $(CURDIR)
endif

ifeq ($(wildcard $(ROOT_DIR)/_local.mk),)
else
	include $(ROOT_DIR)/_local.mk
endif

ifeq ($(wildcard $(ROOT_DIR)/_root.mk),)
	ROOT_DIR := $(ROOT_DIR)/..
	include $(ROOT_DIR)/_dir.mk
else
	include $(ROOT_DIR)/_root.mk
	include $(ROOT_DIR)/_make/dir.mk
endif
