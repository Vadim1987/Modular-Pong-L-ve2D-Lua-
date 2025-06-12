-- collision.lua
local C = require "constants"

local collision = {}

-- Version 1: just reverse horizontal velocity
function collision.basic(ball, paddle)
    ball.vx = -ball.vx
end

-- Version 2: add paddle's vertical speed to ball
function collision.add_paddle_velocity(ball, paddle)
    ball.vx = -ball.vx
    ball.vy = ball.vy + paddle.vy * 0.3
end

collision.STRATEGIES = {
    collision.basic,
    collision.add_paddle_velocity
}

return collision
