IS_TEST := 1
include $(ROOT_DIR)/_make/exe.mk

test:
	$(EXE_ALL)

test_d:
	$(EXE_DEBUG)
