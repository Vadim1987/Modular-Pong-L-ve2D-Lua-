# Modular Pong (LÖVE2D)

> The eternal dance of paddle and pixel, reborn in modular code.

A clean, **modular** version of classic single-player Atari Pong, implemented in [LÖVE2D](https://love2d.org/) and ready for real evolution.  
All gameplay elements are separated into logical modules — no magic numbers, just named constants and clear structure.

## Features

- Player vs. AI or 2-player mode (toggle right paddle between AI and manual)
- **Circular puck** with realistic radius-based collision
- True circle-vs-rectangle collision: if the puck hits a paddle corner, it bounces physically correct (mirrored velocity about tangent)
- All scoring and movement logic updated for new puck shape
- Modular architecture: easy to expand, add new physics, or swap visuals
- - Both paddles can move up/down and left/right, but only up to halfway to the centerline.
- Left paddle controls: WASD (up, down, left, right).
- Ball always receives the full paddle velocity (both axes) upon collision (“smash” the puck!).
- AI opponent can now chase and intercept horizontally as well as vertically.
- Press R to toggle the right paddle between AI and manual control.


...

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

