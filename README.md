# Modular Pong (LÖVE2D)

> The eternal dance of paddle and pixel, reborn in modular code.

A clean, **modular** version of classic single-player Atari Pong, implemented in [LÖVE2D](https://love2d.org/) and ready for real evolution.  
All gameplay elements are separated into logical modules — no magic numbers, just named constants and clear structure.

## Features

- Player vs. AI Pong (left paddle: you, right paddle: computer)
- Four different AI strategies, from perfect bot to silly randomizer
- Two collision strategies for the ball: simple bounce and paddle-velocity physics
- Black-and-white retro field, dotted center line, large readable score
- **Easy to extend:** new physics, circular puck, horizontal paddle movement, crazy themes — you name it

## Controls

- **Player (left paddle):**  
  - Up: `Q`  
  - Down: `A`

- **AI (right paddle):**  
  - Chooses a strategy by code (see `main.lua` and `ai.lua`)

## How to Run

1. [Install LÖVE2D](https://love2d.org/) (version 11.x+ recommended)
2. Clone or download this repo
3. Open the project folder in terminal
4. Run:

