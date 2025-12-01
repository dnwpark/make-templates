# Enter all subdirectories and call make with the same command args.
#
# For example, in a directory like:
# - root
#   - dir_a
#   - dir_b
#
# Running `make all` will do:
#   cd dir_a; make all;
#   cd dir_b; make all;
#
# Subdirectories with the names specified in EXCLUDE_DIRS are skipped.

# Build targets
EXCLUDE_DIRS := _make/ _build/ _lib/ _bin/

SUBDIRS := $(filter-out $(EXCLUDE_DIRS),$(wildcard */))

.PHONY: all debug clean $(SUBDIRS)

all debug clean test test_d: $(SUBDIRS)

# If the subdirectory has a normal makefile, run it.
# Otherwise, run _dir.mk
$(SUBDIRS):
	@cd $@ && \
	if [ -f Makefile ] || [ -f makefile ]; then \
	    $(MAKE) $(MAKECMDGOALS); \
	elif [ -f _dir.mk ]; then \
	    $(MAKE) -f _dir.mk $(MAKECMDGOALS); \
	else \
	    echo "Skipping $@ (no Makefile or _dir.mk)"; \
	fi
