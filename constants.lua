

-- constants.lua
-- All game constants are centralized here for easy tweaking.
local C = {}

C.WINDOW_WIDTH     = 800
C.WINDOW_HEIGHT    = 600

C.PADDLE_WIDTH     = 10
C.PADDLE_HEIGHT    = 60
C.PADDLE_SPEED     = 260
C.PADDLE_MARGIN    = 40

-- C.BALL_SIZE        = 10   
C.BALL_RADIUS      = 10     -- Now the puck’s radius (previously this was the square side)

C.BALL_SPEED       = 220

C.NET_UNIT_SIZE    = 10
C.NET_GAP_SIZE     = 10

C.SCORE_FONT_SIZE  = 40
C.SCORE_TO_WIN     = 10

C.PADDLE_MAX_X_LEFT  = C.WINDOW_WIDTH / 2 - C.PADDLE_MARGIN - C.PADDLE_WIDTH
C.PADDLE_MIN_X_LEFT  = C.PADDLE_MARGIN

C.PADDLE_MAX_X_RIGHT = C.WINDOW_WIDTH - C.PADDLE_MARGIN - C.PADDLE_WIDTH
C.PADDLE_MIN_X_RIGHT = C.WINDOW_WIDTH / 2 + C.PADDLE_MARGIN

C.PADDLE_HSPEED      = 260    -- horizontal speed for paddles (same as vertical, or tweak)


return C
