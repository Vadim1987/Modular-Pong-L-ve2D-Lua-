-- constants.lua

-- Screen
SCREEN_WIDTH  = 640
SCREEN_HEIGHT = 480

-- Game field
PADDLE_WIDTH      = 10
PADDLE_HEIGHT     = 60
BALL_SIZE         = 10
CENTER_LINE_SIZE  = 10
WINNING_SCORE     = 10

-- Paddle positions
PADDLE_OFFSET_X = 30  -- distance from screen edges
LEFT_PADDLE_X   = PADDLE_OFFSET_X
RIGHT_PADDLE_X  = SCREEN_WIDTH - PADDLE_OFFSET_X - PADDLE_WIDTH

-- Initial speeds
PADDLE_SPEED = 200
BALL_SPEED_X = 140
BALL_SPEED_Y = 100

-- Colors (RGB, range: 0 to 1)
COLOR_BACKGROUND = {0, 0, 0}
COLOR_FOREGROUND = {1, 1, 1}

-- Player controls
KEY_UP   = 'q'
KEY_DOWN = 'a'

