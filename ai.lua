-- ai.lua

local AI = {}

-- Perfect AI: always follows the ball
function AI.perfect(paddle, ball, dt)
    local targetY = ball.y + BALL_SIZE / 2 - PADDLE_HEIGHT / 2
    local dir = targetY > paddle.y and 1 or -1
    local vy = dir * PADDLE_SPEED
    local y = paddle.y + vy * dt
    y = math.max(0, math.min(SCREEN_HEIGHT - PADDLE_HEIGHT, y))
    return y, vy
end

-- Very dumb AI: does not move
function AI.static(paddle, ball, dt)
    return paddle.y, 0
end

-- Random jitter AI
function AI.jitter(paddle, ball, dt)
    local vy = (math.random() - 0.5) * 2 * PADDLE_SPEED
    local y = paddle.y + vy * dt
    y = math.max(0, math.min(SCREEN_HEIGHT - PADDLE_HEIGHT, y))
    return y, vy
end

-- Slightly delayed follow
function AI.slow(paddle, ball, dt)
    local offset = 20
    local targetY = ball.y + offset * math.sin(love.timer.getTime())
    local dir = targetY > paddle.y and 0.7 or -0.7
    local vy = dir * PADDLE_SPEED
    local y = paddle.y + vy * dt
    y = math.max(0, math.min(SCREEN_HEIGHT - PADDLE_HEIGHT, y))
    return y, vy
end

return AI
