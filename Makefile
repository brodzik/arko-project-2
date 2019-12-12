CC = gcc
CFLAGS = -Wall -m64
SDLFLAGS = -lmingw32 -lSDL2main -lSDL2 -mwindows  -Wl,--no-undefined -Wl,--dynamicbase -Wl,--nxcompat -Wl,--high-entropy-va -lm -ldinput8 -ldxguid -ldxerr8 -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lshell32 -lsetupapi -lversion -luuid -static-libgcc
SRC_DIR = src
BUILD_DIR = build

all: $(BUILD_DIR)/main.o $(BUILD_DIR)/lissajous.o
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/app $(BUILD_DIR)/main.o $(BUILD_DIR)/lissajous.o $(SDLFLAGS)

$(BUILD_DIR)/lissajous.o: $(SRC_DIR)/lissajous.s
	mkdir -p $(BUILD_DIR)
	nasm -f elf64 -o $(BUILD_DIR)/lissajous.o $(SRC_DIR)/lissajous.s

$(BUILD_DIR)/main.o: $(SRC_DIR)/main.c
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $(BUILD_DIR)/main.o $(SRC_DIR)/main.c

clean:
	rm -rf build/
