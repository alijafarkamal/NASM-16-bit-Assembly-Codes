# Flappy Bird
MADE BY: Sarem Waheed, M. Daniyal Zaidi

## Overview
Welcome to the **Freaky Bird** project! This repository contains an implementation of the classic Flappy Bird game, written in x86 assembly language and designed to run on DOSBox with a 25x80 text mode display.

## Features

- **Text-mode Graphics**: The game uses ASCII characters to render the bird, pipes, and background, making it playable in a 25x80 terminal window.
- **Sound Effects**: Enjoy basic sound effects (using IMF files) to enhance the gaming experience.
- **Challenging Gameplay**: Navigate through gaps in pipes and try to achieve the highest score!

## Files in the Repository

1. **`frekybrd.asm`**
   - The main source code of the game, written in x86 assembly.
2. **`titlescreen.imf`**
   - Music played during the title screen.
3. **`background.imf`**
   - Background music that plays while the game is running after the title screen.

## Prerequisites

To run this project, you will need:

- **DOSBox**: A DOS emulator for running legacy applications.
- **NASM (Netwide Assembler)**: To assemble the `flappybird.asm` file into an executable.
- **Notepad++**: Alternatively, you can skip installing the above two by following [this GitHub repository](https://github.com/ASD0x41/Assembly-Programming-Package), which provides a package including Notepad++, DOSBox, and NASM to simplify setup and avoid any hassle. After installing just press Alt + R to compile and run.

## Controls

- **Spacebar**: Make the bird jump.
- **Esc**: Exit to pause the game.

## Acknowledgments

- Inspired by the original Flappy Bird game by Dong Nguyen.
- Sound effects generated in IMF format for DOS compatibility.

Enjoy the game and happy coding!
