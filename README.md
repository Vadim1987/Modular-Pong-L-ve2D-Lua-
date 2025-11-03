# Pong2D - Two-player Game

In this example, we explore dual input systems,
multiplayer gameplay, collision detection, and game
state management. You will learn how to create a
competitive game where two players face each other
in real time and the game stays stable even when the
frame rate is not.

This variant also shows how to do a **discrete
simulation of a continuous “physical” process** using
a fixed timestep and an accumulator.

```

```
 |   10 : 8   |
 |            |
```

[|] |     []     | [|]
|            |

````

This program implements a two-player Pong game with:
- keyboard and mouse control for left player
- keyboard control for right player
- real-time collision detection
- score tracking and game states
- fixed-timestep update for stable speed


## Concepts Covered

- dual input systems (keyboard + mouse together)
- multiplayer input (two paddles at once)
- game loop (update + draw callbacks)
- collision detection (AABB rectangle overlap)
- state management (start, play, game over)
- fixed timestep with accumulator
- discrete simulation of continuous motion


## Files

**constants.lua** – configuration values

```lua
PADDLE_WIDTH   = 10
PADDLE_HEIGHT  = 60
PADDLE_SPEED   = 180
BALL_SIZE      = 10
BALL_SPEED_X   = 240
BALL_SPEED_Y   = 120
WIN_SCORE      = 10
MOUSE_SENSITIVITY = 1.0
````

**main.lua** – game logic, timing, rendering
and input handling.

## Program Structure

### State Table

All game state is kept in a single global table `S`:

```lua
S = {
  player = {},   -- left paddle
  opp    = {},   -- right paddle
  ball   = {},   -- ball
  playerScore = 0,
  oppScore    = 0,
  state = "start"
}
```

This makes inspection and debugging easier. During
gameplay, you can pause and examine or modify any
value in the `S` table.

### Coordinate System

Screen coordinates start at the top-left corner:

```
(0,0) ────────────> X (right)
  │
  │   [paddle]
  │   at x=30, y=200
  ↓
  Y (down)
```

Moving “up” means decreasing Y, moving “down” means
increasing Y.

## Input Handling

### Left Player – Keyboard

The left player uses Q and A keys:

```lua
function update_left(dt)
  local dir = 0
  if love.keyboard.isDown("q") then
    dir = -1
  elseif love.keyboard.isDown("a") then
    dir = 1
  end
  move_paddle(S.player, dir, dt)
end
```

### Left Player – Mouse

We enable relative mouse mode:

```lua
love.mouse.setRelativeMode(true)
mouseEnabled = true
```

Then use the vertical mouse delta:

```lua
function love.mousemoved(x,y,dx,dy,t)
  if not mouseEnabled then return end
  if t then return end
  if S.state ~= "play" then return end
  local p = S.player
  p.y = p.y + dy * MOUSE_SENSITIVITY
  clamp_paddle(p)
end
```

This allows control without worrying about cursor
position or screen edges.

### Right Player – Keyboard

The right player uses arrow keys:

```lua
function update_right(dt)
  local dir = 0
  if love.keyboard.isDown("up") then
    dir = -1
  elseif love.keyboard.isDown("down") then
    dir = 1
  end
  move_paddle(S.opp, dir, dt)
end
```

## Movement and Physics

### Paddle Movement

Both paddles reuse the same helper:

```lua
function move_paddle(p, dir, dt)
  p.dy = PADDLE_SPEED * dir
  p.y = p.y + p.dy * dt
  clamp_paddle(p)
end
```

This shows how identical code can be shared in
different examples.

### Boundary Clamping

Paddles must stay on the screen:

```lua
function clamp_paddle(p)
  if p.y < 0 then p.y = 0 end
  local maxY = H() - p.h
  if p.y > maxY then p.y = maxY end
end
```

### Ball Motion and Bounce

The ball moves with its own speed and bounces off
top and bottom:

```lua
b.x = b.x + b.dx * dt
b.y = b.y + b.dy * dt
```

If the ball goes above 0 or below screen height, the
vertical component is flipped.

### Collision Detection

We use simple AABB overlap:

```lua
function collide(b, p, offset)
  local hitX  = b.x < p.x + p.w
  local hitX2 = b.x + b.size > p.x
  local hitY  = b.y < p.y + p.h
  local hitY2 = b.y + b.size > p.y
  if hitX and hitX2 and hitY and hitY2 then
    b.x = p.x + offset
    b.dx = -b.dx
  end
end
```

This is enough for Pong-sized objects.

## Fixed-Timestep Update

### Why not just use dt?

On fast desktops `dt` is stable and small. On Compy
the UI, editor, or inspector can pause the frame and
`dt` will suddenly become large. If we just multiply
movement by this large `dt`, the game will look slow
and imprecise.

To avoid that, we measure real time once per frame,
then advance the game in **equal, small steps**.

### How it works

1. Measure real time:

   ```lua
   rdt = now - TIME_T
   TIME_T = now
   ```
2. Add it to an accumulator:

   ```lua
   ACC = ACC + rdt
   ```
3. While we have at least one fixed slice of time
   (1/60 s), we step the game:

   ```lua
   while ACC >= FIXED_DT do
     step_game(FIXED_DT)
     ACC = ACC - FIXED_DT
   end
   ```

This is the “discrete simulation of a continuous
process”: real time flows smoothly, but we simulate
it in small fixed jumps. Motion stays consistent.

## Scoring and Game States

When the ball passes a paddle, we add a point to the
opposite side. When one side reaches `WIN_SCORE`,
the game moves to `"gameover"` state. Pressing Space
returns to `"start"` and allows playing again.

## Pitfalls and How to Avoid Them

### 1. Ball passes through the paddle

If the ball is too fast and the timestep is too big,
the ball can go from “left of paddle” to “right of
paddle” in one step and never overlap it.

**Avoid this:**

* keep `BALL_SPEED_X * FIXED_DT` smaller than paddle
  thickness
* do not set `SPEED_SCALE` too high
* or lower `FIXED_DT` if you speed the game up

### 2. Too many steps per frame

If a frame is very slow, the accumulator may contain
a lot of time. Running all steps at once will block
drawing.

**Avoid this:**

* keep a cap like `MAX_STEPS = 5`
* if you hit the cap often, profile or reduce work
  in the update

### 3. Mixing fixed and variable time

All position changes should happen in the fixed-step
function (`step_game`). Do not also move objects in
`love.draw()` or in mouse handlers outside of play
state. Otherwise motion will look uneven.

### 4. Overshooting with speed scale

`SPEED_SCALE` is a convenient knob. It multiplies the
effective dt that the game logic sees. If you push it
too far, you reintroduce tunneling. Increase slowly.

### 5. Assuming dt is always called

Some environments may skip update calls when paused.
Always re-measure time (`love.timer.getTime()`) and
feed it into the accumulator, as done here.

## User Documentation

This is a two-player Pong game.

**Controls:**

* Left: `Q` up, `A` down, or mouse move
* Right: `↑` up, `↓` down
* `Space` – start / restart
* `Esc` – quit

The first player to reach the target score wins.

## Summary

This program does not only show “how to draw Pong”.
It also shows how to keep the game running at the
same speed even when the environment is slow, by
using a fixed timestep and discrete updates. This
pattern can be reused in other arcade examples so
they all behave consistently on Compy.

