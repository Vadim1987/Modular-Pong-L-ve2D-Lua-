-- constants.lua

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

-- Horizontal movement limits (paddles can move up to halfway to the centerline)
LEFT_PADDLE_MIN_X  = PADDLE_OFFSET_X
LEFT_PADDLE_MAX_X  = (SCREEN_WIDTH / 2) - PADDLE_WIDTH - 2
RIGHT_PADDLE_MIN_X = (SCREEN_WIDTH / 2) + 2
RIGHT_PADDLE_MAX_X = SCREEN_WIDTH - PADDLE_OFFSET_X - PADDLE_WIDTH

-- Ball
BALL_RADIUS     = 10    -- radius of the circular ball
BALL_SIZE       = BALL_RADIUS * 2
BALL_SPEED_X    = 160
BALL_SPEED_Y    = 60

-- Game
WINNING_SCORE   = 10

-- Colors
COLOR_BG        = {0, 0, 0}
COLOR_FG        = {1, 1, 1}

-- Controls
LEFT_PADDLE_UP     = 'w'
LEFT_PADDLE_DOWN   = 's'
LEFT_PADDLE_LEFT   = 'a'
LEFT_PADDLE_RIGHT  = 'd'
RIGHT_PADDLE_UP    = 'up'
RIGHT_PADDLE_DOWN  = 'down'
RIGHT_PADDLE_LEFT  = 'left'
RIGHT_PADDLE_RIGHT = 'right'

