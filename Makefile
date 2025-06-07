NASM = nasm
CC = gcc
LD = ld
GRUB_MKRESCUE = grub-mkrescue
OBJCOPY = objcopy

BOOTLOADER_SRC = bootloader/vobootloader.asm
BOOTLOADER_BIN = build/vobootloader.bin

KERNEL_SRC = kernel/vokernel.c
KERNEL_OBJ = build/vokernel.o
KERNEL_BIN = build/vokernel.bin

ISO_DIR = build/iso
ISO_IMG = build/voiled_os.iso

.PHONY: all clean iso

all: $(ISO_IMG)

# Assemble bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(NASM) -f bin $< -o $@

# Compile kernel (32-bit freestanding)
$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) -m32 -ffreestanding -c $< -o $@

# Link kernel ELF
$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) -m elf_i386 -T linker.ld -o kernel.elf $(KERNEL_OBJ)
	$(OBJCOPY) -O binary kernel.elf $@

# Prepare ISO folder structure
$(ISO_DIR):
	mkdir -p $(ISO_DIR)/boot/grub

# Copy bootloader and kernel to ISO folder + grub.cfg
iso: $(ISO_DIR) $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cp $(BOOTLOADER_BIN) $(ISO_DIR)/boot/
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/
	cp grub.cfg $(ISO_DIR)/boot/grub/

# Build ISO image using grub-mkrescue
$(ISO_IMG): iso
	$(GRUB_MKRESCUE) -o $@ $(ISO_DIR)

clean:
	rm -rf build/*
	rm -f kernel.elf


