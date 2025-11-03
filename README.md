
# Pong2D. Single player
In this example, we explore how to make a complete
two-player game with moving objects, simple physics,
and its own drawing function. This version of Pong
is written for Compy and uses a fixed timestep for
stable motion, even when the program runs slowly.

--------------------------------------------------

### Overview

Pong is one of the simplest arcade games. Two paddles
move up and down and bounce a ball back and forth.
Each time the ball passes a paddle, the other player
scores a point.

This program builds the full game using the LOVE2D
framework. We will define our state, draw it to the
screen, and update it over time.


### Setting up the screen

We begin by measuring the size of the screen window
and storing it in two global variables:

```lua
WW = love.graphics.getWidth()
WH = love.graphics.getHeight()
````

We also keep helper functions to find the center:

```lua
function cx(s) return WW / 2 - s / 2 end
function cy(s) return WH / 2 - s / 2 end
```

This lets us easily center the ball and paddles.



### Game state

All state is stored in one table called `S`. It holds
the position and speed of both paddles and the ball,
and the current scores.

```lua
S = {
  player = {x=24, y=0, w=10, h=60, dy=0},
  opp = {x=0, y=0, w=10, h=60, dy=0},
  ball = {x=0, y=0, dx=180, dy=140, size=8},
  playerScore = 0,
  oppScore = 0,
  state = "start"
}
```

Having all game data in one place makes it easier to
reset or inspect from the Compy console.



### Drawing the scene

We use the `love.draw()` function to take over the
screen drawing. Each frame, we clear the background
and draw the paddles, ball, and score.

```lua
function love.draw()
  love.graphics.clear(0.08, 0.08, 0.08)
  love.graphics.setColor(1, 1, 1)
  draw_paddle(S.player)
  draw_paddle(S.opp)
  draw_ball(S.ball)
  draw_scores()
end
```

This function is called automatically by the system.
Each call draws one complete frame.



### Input handling

The player can use the keyboard or mouse to move the
paddle. The keys `Q` and `A` move it up and down.

For mouse control, we use *relative mode*:

```lua
love.mouse.setRelativeMode(true)
```

In this mode, the mouse reports only movement change,
not absolute position. This allows smooth control even
if the cursor would leave the screen.

The AI opponent follows the ball by comparing its own
center to the ball’s center and moving toward it.



### The ball and collisions

The ball moves each frame according to its speed:

```lua
b.x = b.x + b.dx * dt
b.y = b.y + b.dy * dt
```

When it hits the top or bottom of the screen, its
vertical direction is reversed:

```lua
if b.y <= 0 or b.y >= WH - b.size then
  b.dy = -b.dy
end
```

When it overlaps a paddle, its horizontal direction
is reversed and its angle slightly adjusted based on
where it struck the paddle.



### Time and update loop

Unlike many simpler programs, here we do not rely on
the raw `dt` (delta time) value given by LOVE2D.

In Compy, frame updates can be irregular. This makes
movement appear slower or faster depending on how long
the frame took. To fix this, we simulate time in small
equal steps, called a **fixed timestep**.

Each frame, we measure the real time passed:

```lua
rdt = love.timer.getTime() - TIME_T
TIME_T = love.timer.getTime()
```

We add that time to an accumulator:

```lua
ACC = ACC + rdt
```

While the accumulator has at least one small step of
time (1/60 second), we update the game by that step:

```lua
while ACC >= FIXED_DT do
  step_game(FIXED_DT)
  ACC = ACC - FIXED_DT
end
```

This means the game always advances at the same speed
regardless of how many frames per second we draw.



### What “discrete simulation” means

Real time is continuous, but the computer updates
the world in small jumps. Each jump is one *tick* of
the simulation. This is called a **discrete model**.

For example, at 60 ticks per second, the ball moves
a small distance sixty times a second. If the frame
rate slows down, we simply perform several small
steps during the next frame to catch up.

This ensures stable, predictable motion.


### Common pitfalls

1. **Tunneling through paddles**

   If the ball moves too far in one tick, it can skip
   past a paddle without touching it.
   To avoid this, keep the speed low enough so that
   the ball travels less than the paddle thickness in
   one step.

2. **Too many steps per frame**

   If a frame takes too long, the game may try to run
   hundreds of steps at once and never draw again.
   We limit this with a `MAX_STEPS` value, usually 5.

3. **Mixing fixed and variable time**

   Update all game state only inside the fixed-step
   function. Do not also change positions elsewhere,
   or motion will become inconsistent.

4. **Unstable speeds**

   The constant `SPEED_SCALE` can increase or reduce
   the overall pace. Too high a value can again cause
   tunneling; increase gradually.


