-- ai.lua
local C = require "constants"

local ai = {}

-- Strategy 1: Perfect tracking
function ai.perfect(paddle, ball)
    if ball.y < paddle.y then
        return true, false
    elseif ball.y + C.BALL_SIZE > paddle.y + C.PADDLE_HEIGHT then
        return false, true
    end
    return false, false
end

-- Strategy 2: Slow follower
function ai.slow(paddle, ball)
    if ball.y < paddle.y then
        return true, false
    elseif ball.y + C.BALL_SIZE > paddle.y + C.PADDLE_HEIGHT then
        return false, true
    end
    return false, false
end

-- Strategy 3: Only reacts if ball is close
function ai.lazy(paddle, ball)
    if math.abs(ball.x - paddle.x) < C.WINDOW_WIDTH / 4 then
        return ai.perfect(paddle, ball)
    end
    return false, false
end

-- Strategy 4: Occasional random miss
function ai.random_miss(paddle, ball)
    if math.random() < 0.97 then
        return ai.perfect(paddle, ball)
    else
        return false, false
    end
end

ai.STRATEGIES = {
    ai.perfect,
    ai.slow,
    ai.lazy,
    ai.random_miss
}

return ai
