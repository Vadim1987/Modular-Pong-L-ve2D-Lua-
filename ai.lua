-- ai.lua

local AI = {}

-- "Smart" AI: follows ball horizontally and vertically, predicts future position
function AI.smart(paddle, ball, dt)
    -- Target is the predicted intersection with paddle's y-plane
    local futureX = ball.x + ball.vx * 0.5  -- simple prediction (can be improved)
    local targetY = ball.y - PADDLE_HEIGHT / 2
    local targetX

    if paddle.side == "right" then
        targetX = math.max(RIGHT_PADDLE_MIN_X, math.min(futureX, RIGHT_PADDLE_MAX_X))
    else
        targetX = math.max(LEFT_PADDLE_MIN_X, math.min(futureX, LEFT_PADDLE_MAX_X))
    end

    local dirY = targetY > paddle.y and 1 or -1
    local dirX = targetX > paddle.x and 1 or -1

    local vy = math.abs(targetY - paddle.y) < 5 and 0 or dirY * PADDLE_SPEED
    local vx = math.abs(targetX - paddle.x) < 5 and 0 or dirX * PADDLE_SPEED

    local y = math.max(0, math.min(SCREEN_HEIGHT - PADDLE_HEIGHT, paddle.y + vy * dt))
    local x
    if paddle.side == "right" then
        x = math.max(RIGHT_PADDLE_MIN_X, math.min(RIGHT_PADDLE_MAX_X, paddle.x + vx * dt))
    else
        x = math.max(LEFT_PADDLE_MIN_X, math.min(LEFT_PADDLE_MAX_X, paddle.x + vx * dt))
    end
    return y, vy, x, vx
end

return AI




