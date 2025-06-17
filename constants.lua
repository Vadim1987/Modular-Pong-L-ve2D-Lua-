-- constants.lua

local C = {}

C.WINDOW_WIDTH     = 800
C.WINDOW_HEIGHT    = 600

C.PADDLE_WIDTH     = 10
C.PADDLE_HEIGHT    = 60
C.PADDLE_SPEED     = 260
C.PADDLE_MARGIN    = 40

C.BALL_SIZE        = 10
C.BALL_SPEED       = 220

C.NET_UNIT_SIZE    = 10
C.NET_GAP_SIZE     = 10

C.SCORE_FONT_SIZE  = 40
C.SCORE_TO_WIN     = 1

-- Player 1 (left paddle) controls
C.KEY_UP   = 'w'      
C.KEY_DOWN = 's'      

-- Player 2 (right paddle) controls for manual opponent mode
C.KEY_RIGHT_UP   = 'up'
C.KEY_RIGHT_DOWN = 'down'

-- Toggle: set to true for two-player mode (manual right paddle)
C.MANUAL_OPPONENT = true

-- Ball properties
C.BALL_RADIUS = C.BALL_SIZE 

return C
