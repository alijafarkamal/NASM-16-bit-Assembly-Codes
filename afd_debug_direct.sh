#!/bin/bash

# Check if a file name was provided
if [ -z "$1" ]; then
  echo "Usage: $0 filename.asm"
  exit 1
fi

# Set the file name
ASM_FILE="$1"
BASENAME=$(basename "$ASM_FILE" .asm)
COM_FILE="${BASENAME}.com"
LST_FILE="${BASENAME}.lst"

# Check if the file exists
if [ ! -f "$ASM_FILE" ]; then
  echo "Error: File $ASM_FILE does not exist."
  exit 1
fi

# Assemble the .asm file into .com and generate .lst file
nasm -f bin "$ASM_FILE" -o "$COM_FILE" -l "$LST_FILE"

# Check if the .com file was created
if [ ! -f "$COM_FILE" ]; then
  echo "Error: Failed to create $COM_FILE."
  exit 1
fi

# Check if the .lst file was created
if [ ! -f "$LST_FILE" ]; then
  echo "Error: Failed to create $LST_FILE."
  exit 1
fi

# Start DOSBox and run the .com file directly, skipping the debugger
dosbox -c "mount c \"/home/ali-jafar/Home/Assembly Programming Tools\"" \
       -c "c:" \
       -c "$COM_FILE"

