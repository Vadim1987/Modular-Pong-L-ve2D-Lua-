-- collision.lua

local Collision = {}

local function clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

local function circleRectCollision(ball, paddle)
    local closestX = clamp(ball.x, paddle.x, paddle.x + PADDLE_WIDTH)
    local closestY = clamp(ball.y, paddle.y, paddle.y + PADDLE_HEIGHT)
    local dx = ball.x - closestX
    local dy = ball.y - closestY
    local distSq = dx * dx + dy * dy
    if distSq < BALL_RADIUS * BALL_RADIUS then
        local length = math.sqrt(distSq)
        if length == 0 then
            ball.vx = -ball.vx
        else
            local nx = dx / length
            local ny = dy / length
            local dot = ball.vx * nx + ball.vy * ny
            ball.vx = ball.vx - 2 * dot * nx
            ball.vy = ball.vy - 2 * dot * ny
        end
        -- Push ball out
        if ball.x < SCREEN_WIDTH / 2 then
            ball.x = paddle.x + PADDLE_WIDTH + BALL_RADIUS
        else
            ball.x = paddle.x - BALL_RADIUS
        end
        return true
    end
    return false
end

function Collision.add_paddle_velocity(ball, paddle)
    if circleRectCollision(ball, paddle) then
        ball.vx = ball.vx + paddle.vx
        ball.vy = ball.vy + paddle.vy
    end
end

return Collision

         

