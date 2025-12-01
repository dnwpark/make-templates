# # inputs
# LIB_NAME = X # library name
# 
# INCLUDES = -I$(LOCAL_SRC_PATH) # include flags
# 
# SRCS = $(wildcard *.cpp)  # source files. (optional, defaults to $(wildcard *.cpp))
# OUTPUT_DIR = ..           # output directory. (optional, defaults to $(LOCAL_BIN_PATH) or ..)

IS_LIB := 1
include $(ROOT_DIR)/_make/bin_base.mk

# Files and directories
CFLAGS_ALL = $(CFLAGS_ALL_COMMON)
OBJ_DIR_ALL = $(LOCAL_BUILD_PATH)/$(LIB_NAME)
OBJS_ALL = $(SRCS:%.cpp=$(OBJ_DIR_ALL)/%.o)
LIB_ALL_NAME = $(LIB_NAME).a
LIB_ALL = $(OUTPUT_DIR)/$(LIB_ALL_NAME)

CFLAGS_DEBUG = $(CFLAGS_DEBUG_COMMON)
OBJ_DIR_DEBUG = $(LOCAL_BUILD_PATH)/$(LIB_NAME)_d
OBJS_DEBUG = $(SRCS:%.cpp=$(OBJ_DIR_DEBUG)/%.o)
LIB_DEBUG_NAME = $(LIB_NAME)_d.a
LIB_DEBUG = $(OUTPUT_DIR)/$(LIB_DEBUG_NAME)

DEP_ALL = $(OBJS_ALL:%.o=%.d)
DEP_DEBUG = $(OBJS_DEBUG:%.o=%.d)
-include $(DEP_ALL)
-include $(DEP_DEBUG)

# Library makefile
.PHONY: depend clean

# all
all: $(LIB_ALL)

$(LIB_ALL): $(OBJS_ALL)
	@mkdir -p $(OUTPUT_DIR)
	ar rcs -o $(LIB_ALL) $(OBJS_ALL)

$(OBJ_DIR_ALL)/%.o: %.cpp
	@mkdir -p $(OBJ_DIR_ALL)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CFLAGS_ALL) $(INCLUDES) -MMD -MP -c $< -o $@

# debug
debug: $(LIB_DEBUG)

$(LIB_DEBUG): $(OBJS_DEBUG)
	@mkdir -p $(OUTPUT_DIR)
	ar rcs -o $(LIB_DEBUG) $(OBJS_DEBUG)

$(OBJ_DIR_DEBUG)/%.o: %.cpp
	@mkdir -p $(OBJ_DIR_DEBUG)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CFLAGS_DEBUG) $(INCLUDES) -MMD -MP -c $< -o $@

# clean
clean:
	$(RM) $(OBJ_DIR_ALL)/*.o $(OBJ_DIR_ALL)/*.d $(LIB_ALL)
	$(RM) $(OBJ_DIR_DEBUG)/*.o $(OBJ_DIR_DEBUG)/*.d $(LIB_DEBUG)

depend: $(SRCS)
	makedepend $(INCLUDES) $^
