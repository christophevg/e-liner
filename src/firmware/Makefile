DEVICE   ?= 340034001447353236343033
PROJECT  ?= servo
PARTICLE ?= particle
TTY      ?= /dev/tty.usbmodemFD121
BAUDRATE ?= 9600
SCREEN   ?= screen $(TTY) $(BAUDRATE)

-include $(PROJECT)/Makefile

all: flash console

console:
ifdef CONSOLE
	@sleep 2
	@echo "*** Starting console output. Terminate using 'Ctrl+a k y'."
	@echo "    Press any key to continue..."
	@read
	@$(SCREEN)
else
	@echo
endif

flash:
	@echo "*** compiling and flashing project $(PROJECT)"
	$(PARTICLE) flash $(DEVICE) $(PROJECT)
