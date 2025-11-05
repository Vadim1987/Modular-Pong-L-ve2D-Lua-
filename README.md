# Pong2 with square ball

This example shows how to build a small real-time game step by
step. It demonstrates how to structure a program, store all state
in one table, update the world in small fixed time steps, and draw
the result every frame.

The approach used here also helps overcome the limited performance
of Compy hardware by keeping updates deterministic and efficient.


### 1. Files and purpose

The project has three files:

- **constants.lua** — numbers that never change: sizes, colors,
  speeds. 
- **strategy.lua** — code that decides how the right paddle moves.
  It can follow the ball (AI) or be controlled by a second player.
- **main.lua** — the main program. It sets up the screen,
  initializes state, runs the update loop and draws the picture.

Separating logic, constants, and behavior keeps the program
readable and efficient.



### 2. Constants

In `constants.lua` you find lines like:

```lua
PADDLE_WIDTH   = 10
PADDLE_HEIGHT  = 60
BALL_SIZE      = 10
AI_DEADZONE    = 4
COLOR_FG       = {1, 1, 1}
COLOR_BG       = {0, 0, 0}

These describe the world. They are read by main.lua but never
change while the game runs. Because they are constants, Compy can
keep them in faster memory.



3. Game state

All moving objects and scores live in one table S:

S = {
  player = { x, y, w, h, dy },
  opp    = { x, y, w, h, dy },
  ball   = { x, y, dx, dy, size },
  playerScore = 0,
  oppScore    = 0,
  state = "start"
}

The program updates these values each step and then draws them.
Keeping everything together makes it easy to inspect and debug.

⸻

4. Setting up the screen

At startup, cache_dims() measures the screen once and stores:

screen_w, screen_h = G.getDimensions()
paddle_max_y = screen_h - PADDLE_HEIGHT
ball_max_y   = screen_h - BALL_SIZE
center_x     = math.floor(screen_w / 2 + 0.5)

By caching these values the program avoids repeated system calls
each frame — an important optimization on Compy, where GPU and CPU
access are expensive.

⸻

5. Drawing the scene

All drawing happens inside love.draw():
	1.	Clear the screen.
	2.	Draw the cached divider canvas.
	3.	Draw paddles, ball, and scores.
	4.	Draw text messages such as “Press Space”.

Example:

function love.draw()
  cache_dims()
  G.clear(COLOR_BG)
  G.setColor(COLOR_FG)
  G.draw(CENTER_CANVAS)
  draw_paddle(S.player)
  draw_paddle(S.opp)
  draw_ball(S.ball)
  draw_scores()
  draw_state_text()
end

Drawing only from cached data keeps rendering predictable even on
slow devices.

⸻

6. Input and control

The left paddle can be moved with the mouse or keys Q and A.

The right paddle uses a strategy selected at startup:

strategy.set_opp_strategy("ai")

for a computer opponent, or

strategy.set_opp_strategy("manual")

for a second human using arrow keys.

Press Space to start or restart; Escape to quit.



7. The update loop

love.update(dt) is called many times per second. The program
measures real time since the previous frame and runs a fixed-step
simulation to keep motion stable even if the frame rate changes.

acc = acc + rdt
while acc >= FIXED_DT and steps < MAX_STEPS do
  step_game(FIXED_DT)
  acc = acc - FIXED_DT
  steps = steps + 1
end

FIXED_DT is the duration of one physics step (1/60 s).
MAX_STEPS limits the number of updates per frame so Compy never
freezes when rendering slows down.



8. What happens in one step

Each call to step_game(dt) advances the world by one quantum of
time:

update_player(dt)
strategy.update(S, dt)
move_ball(S.ball, dt)
bounce_ball(S.ball)
collide(S.ball, S.player, S.player.w)
collide(S.ball, S.opp, -S.ball.size)
check_score()

These operations are simple arithmetic updates, chosen to be fast
enough for Compy’s limited processor. The combination of short
steps and minimal math gives smooth motion without heavy load.



9. Opponent strategies

strategy.lua defines how the right paddle moves.

AI strategy

local d = (S.ball.y + S.ball.size/2) -
          (S.opp.y + S.opp.h/2)
if math.abs(d) > AI_DEADZONE then
  move_paddle(S.opp, (d > 0) and 1 or -1, dt)
end

The paddle follows the ball but pauses inside a small “dead zone”
so it does not react instantly.

Manual strategy

Reads the arrow keys:

if love.keyboard.isDown("up") then dir = -1
elseif love.keyboard.isDown("down") then dir = 1 end
move_paddle(S.opp, dir, dt)

Any new behavior can be added as:

strategy.set_opp_strategy("custom", function(S, dt)
  -- your logic here
end)

Because the module is separate, the game code stays clean.


10. Discrete simulation and Compy performance

The discrete, fixed-step simulation is not only a teaching tool.
It is also a performance solution.

On Compy, frame rate and CPU speed can vary between devices.
If physics were tied directly to dt, motion would become slower
or faster depending on load.

By processing time in small equal slices, the game ensures that
movement, collisions, and scoring behave identically on all units,
no matter how many frames per second are drawn.

In short, discrete time keeps the game fair and efficient even
on limited hardware.


11. Common issues
	•	Tunneling: a fast ball may skip a paddle if the time step is
too large. Reduce ball speed or lower FIXED_DT.
	•	Frame drop: if too many updates pile up, the loop stops at
MAX_STEPS and the game slows slightly instead of freezing.
	•	Mixed timing: always use fixed dt for physics and real dt
only for animation or timers.
	•	High SPEED_SCALE: makes movement faster but less accurate.



