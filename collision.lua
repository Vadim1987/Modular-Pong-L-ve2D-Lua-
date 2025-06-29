-- collision.lua

local Collision = {}

function Collision.basic(ball, paddle)
    ball.vx = -ball.vx
end

function Collision.add_paddle_velocity(ball, paddle)
    ball.vx = -ball.vx
    ball.vy = ball.vy + 0.5 * paddle.vy
end

return Collision
