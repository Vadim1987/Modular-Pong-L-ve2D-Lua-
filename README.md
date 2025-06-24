# Modular Pong (Löve2D, Lua)

Minimal, extensible Pong for Löve2D. Pure Lua. Oldschool spirit, newschool code.

## Controls
- Player (left paddle): Q = up, A = down, or mouse (hold left mouse button and move up/down)
- Computer: 4 strategies available; default is “perfect”
- Restart after game over: SPACE

- Left paddle:      W/S = up/down, A/D = left/right
- Right paddle:     Arrow keys (in manual mode), otherwise AI
- Press Tab to switch AI modes
- Space to restart after win


## Run 
love .


## Structure
- main.lua — main loop
- constants.lua — all dimensions & parameters
- paddle.lua — paddle class
- ball.lua — ball class
- ai.lua — AI strategies
- collision.lua — collision logic


