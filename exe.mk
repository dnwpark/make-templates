# # Inputs
# EXE_NAME = app
# 
# COMMON_LIB_NAMES = math
# LOCAL_LIB_NAMES = stuff
# LFLAGS = -lmingw32
# 
# INCLUDES = -L$(LOCAL_SRC_PATH) -I$(COMMON_LIB_SRC_PATH) -I$(3RD_PARTY_PATH)
# LIB_PATHS = -L$(LOCAL_LIB_PATH) -L$(COMMON_LIB_LIB_PATH)
# 
# SRCS = $(wildcard *.cpp)  # source files (optional, defaults to $(wildcard *.cpp))
# OUTPUT_DIR = ..           # output directory. (optional, defaults to $(LOCAL_BIN_PATH) or ..)

IS_BIN := 1
include $(ROOT_DIR)/_make/bin_base.mk

# Files and directories
CFLAGS_ALL = $(CFLAGS_ALL_COMMON)
OBJ_DIR_ALL = $(LOCAL_BUILD_PATH)/$(EXE_NAME)
OBJS_ALL = $(SRCS:%.cpp=$(OBJ_DIR_ALL)/%.o)
EXE_ALL_NAME = $(EXE_NAME).exe
EXE_ALL = $(OUTPUT_DIR)/$(EXE_ALL_NAME)

CFLAGS_DEBUG = $(CFLAGS_DEBUG_COMMON)
OBJ_DIR_DEBUG = $(LOCAL_BUILD_PATH)/$(EXE_NAME)_d
OBJS_DEBUG = $(SRCS:%.cpp=$(OBJ_DIR_DEBUG)/%.o)
EXE_DEBUG_NAME = $(EXE_NAME)_d.exe
EXE_DEBUG = $(OUTPUT_DIR)/$(EXE_DEBUG_NAME)

LFLAGS_ALL = $(LOCAL_LIB_NAMES:%=-l%) $(COMMON_LIB_NAMES:%=-l%)
LFLAGS_DEBUG = $(LOCAL_LIB_NAMES:%=-l%_d) $(COMMON_LIB_NAMES:%=-l%_d)
COMMON_LIB_ALL_FILES = $(COMMON_LIB_NAMES:%=$(COMMON_LIB_LIB_PATH)/lib%.a)
COMMON_LIB_DEBUG_FILES = $(COMMON_LIB_NAMES:%=$(COMMON_LIB_LIB_PATH)/lib%_d.a)
LOCAL_LIB_ALL_FILES = $(LOCAL_LIB_NAMES:%=$(LOCAL_BIN_PATH)/lib%.a)
LOCAL_LIB_DEBUG_FILES = $(LOCAL_LIB_NAMES:%=$(LOCAL_BIN_PATH)/lib%_d.a)

DEP_ALL = $(OBJS_ALL:%.o=%.d)
DEP_DEBUG = $(OBJS_DEBUG:%.o=%.d)
-include $(DEP_ALL)
-include $(DEP_DEBUG)

# Application makefile
.PHONY: clean depend test test_d

# all
all: $(EXE_ALL)

$(EXE_ALL): $(COMMON_LIB_ALL_FILES) $(LOCAL_LIB_ALL_FILES) $(OBJS_ALL)
	@mkdir -p $(OUTPUT_DIR)
	$(CC) $(LIB_PATHS) -o $(EXE_ALL) $(OBJS_ALL) $(LFLAGS_ALL) $(LFLAGS)

$(COMMON_LIB_LIB_PATH)/lib%.a:
	cd $(COMMON_LIB_SRC_PATH)/$*; make all;

$(LOCAL_BIN_PATH)/lib%.a:
	cd $(LOCAL_SRC_PATH)/$*; make all;

$(OBJ_DIR_ALL)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CFLAGS_ALL) $(INCLUDES) -MMD -MP -c $< -o $@

# debug
debug: $(EXE_DEBUG)

$(EXE_DEBUG): $(COMMON_LIB_DEBUG_FILES) $(LOCAL_LIB_DEBUG_FILES) $(OBJS_DEBUG)
	@mkdir -p $(OUTPUT_DIR)
	$(CC) $(LIB_PATHS) -o $(EXE_DEBUG) $(OBJS_DEBUG) $(LFLAGS_DEBUG) $(LFLAGS)

$(COMMON_LIB_LIB_PATH)/lib%_d.a:
	cd $(COMMON_LIB_SRC_PATH)/$*; make debug;

$(LOCAL_BIN_PATH)/lib%_d.a:
	cd $(LOCAL_SRC_PATH)/$*; make debug;

$(OBJ_DIR_DEBUG)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CFLAGS_DEBUG) $(INCLUDES) -MMD -MP -c $< -o $@

# clean
clean:
	$(RM) $(EXE_ALL)
	$(RM) $(EXE_DEBUG)
	$(RM) $(OBJ_DIR_ALL)/*.o $(OBJ_DIR_ALL)/*.d $(DEP_ALL)
	$(RM) $(OBJ_DIR_DEBUG)/*.o $(OBJ_DIR_DEBUG)/*.d $(DEP_DEBUG)

depend: $(SRCS)
	makedepend $(INCLUDES) $^
