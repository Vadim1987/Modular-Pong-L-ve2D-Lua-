-- collision.lua

local Collision = {}

local function clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

-- Circle vs Rectangle collision and tangent bounce
local function circleRectCollision(ball, paddle)
    -- Find closest point on paddle to ball center
    local closestX = clamp(ball.x, paddle.x, paddle.x + PADDLE_WIDTH)
    local closestY = clamp(ball.y, paddle.y, paddle.y + PADDLE_HEIGHT)
    local dx = ball.x - closestX
    local dy = ball.y - closestY
    local distSq = dx * dx + dy * dy
    if distSq < BALL_RADIUS * BALL_RADIUS then
        local length = math.sqrt(distSq)
        if length == 0 then
            -- Center of ball is exactly on corner, just flip x velocity
            ball.vx = -ball.vx
        else
            -- Reflect velocity over the tangent (normal to the contact point)
            local nx = dx / length
            local ny = dy / length
            local dot = ball.vx * nx + ball.vy * ny
            ball.vx = ball.vx - 2 * dot * nx
            ball.vy = ball.vy - 2 * dot * ny
        end
        -- Push ball out so it doesn't stick
        if ball.x < SCREEN_WIDTH / 2 then
            ball.x = paddle.x + PADDLE_WIDTH + BALL_RADIUS
        else
            ball.x = paddle.x - BALL_RADIUS
        end
    end
end

function Collision.basic(ball, paddle)
    circleRectCollision(ball, paddle)
end

function Collision.add_paddle_velocity(ball, paddle)
    local beforeVy = ball.vy
    circleRectCollision(ball, paddle)
    -- Adds a portion of paddle velocity to ball after collision
    ball.vy = ball.vy + 0.5 * paddle.vy
end

return Collision
