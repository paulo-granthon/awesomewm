SCRIPTS = \
	verify_theme.bash \
	picom.bash \
	tail_awesome_logs.bash

# Target to make all scripts executable
chmod_scripts:
	chmod +x $(SCRIPTS)

# Target to clean up (remove executable permission)
clean:
	chmod -x $(SCRIPTS)

# Default target
all: chmod_scripts
