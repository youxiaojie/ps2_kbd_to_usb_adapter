# makefile for Adafruit ATmega32u4 breakout board
# references:
#    http://ladyada.net/products/atmega32u4breakout/
#  How to get started with the Atmega32u4 Breakout Board+ on Linux
#    https://forums.adafruit.com/viewtopic.php?f=24&t=23266

SRC = ps2_kbd_to_usb_adapter.cpp PS2Keyboard.cpp
OUT = ps2_kbd_to_usb_adapter.elf

SRC = tst.cpp
OUT = tst.elf

DEFINES = F_CPU=16000000

# defines to [ab]use the arduino libraries
#DEFINES += ARDUINO=101
#INCDIRS = /usr/share/arduino/hardware/arduino/cores/arduino/ /usr/share/arduino/hardware/arduino/variants/leonardo

CFLAGS = -mmcu=atmega32u4 -Os -Wall $(DEFINES:%=-D%) $(INCDIRS:%=-I%)
LDFLAGS = 

OBJ = $(filter %.o, $(SRC:%.c=%.o) $(SRC:%.cpp=%.o))

all : $(OUT)

# compile c
%.o : %.c
	avr-gcc $(CFLAGS) -c $< -o $@

# compile c++
%.o : %.cpp
	avr-g++ $(CFLAGS) -c $< -o $@

# link
$(OUT) : $(OBJ)
	avr-gcc $(CFLAGS) $(LDFLAGS) $^ -o $@

# clean outputs
clean :
	rm $(OBJ) $(OUT)

# program
flash : $(OUT)
	avrdude -p m32u4 -P /dev/ttyACM0 -c avr109 -U flash:w:$<:a

.PHONY : all flash clean
.SECONDARY : $(OUT)
.PRECIOUS : $(OBJ)
