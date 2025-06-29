-- constants.lua
-- All game-wide constants in one place

-- Screen
SCREEN_WIDTH    = 640
SCREEN_HEIGHT   = 480

-- Field
FIELD_PADDING   = 40

-- Paddle
PADDLE_WIDTH    = 10
PADDLE_HEIGHT   = 60
PADDLE_SPEED    = 240  -- units/sec
PADDLE_OFFSET_X = 32   -- Distance from edge

-- Ball
BALL_RADIUS     = 10    -- now main parameter for ball size (circular)
BALL_SIZE       = BALL_RADIUS * 2  -- legacy, for center line, etc.
BALL_SPEED_X    = 160
BALL_SPEED_Y    = 60

-- Game
WINNING_SCORE   = 10

-- Colors (LÖVE uses [0,1])
COLOR_BG        = {0, 0, 0}
COLOR_FG        = {1, 1, 1}

-- Controls
LEFT_PADDLE_UP     = 'q'
LEFT_PADDLE_DOWN   = 'a'
RIGHT_PADDLE_UP    = 'up'
RIGHT_PADDLE_DOWN  = 'down'

