-- physics.lua
local physics = {}

-- Reflect vector (vx, vy) over normal (nx, ny)
local function reflect(vx, vy, nx, ny)
    -- Normalize normal
    local len = math.sqrt(nx * nx + ny * ny)
    nx = nx / len
    ny = ny / len

    -- Dot product of velocity and normal
    local dot = vx * nx + vy * ny

    -- Reflect
    local rx = vx - 2 * dot * nx
    local ry = vy - 2 * dot * ny
    return rx, ry
end

-- Check and resolve circle-rectangle collision
function physics.checkPaddleCollision(ball, paddle)
    local closestX = math.max(paddle.x, math.min(ball.x, paddle.x + paddle.width))
    local closestY = math.max(paddle.y, math.min(ball.y, paddle.y + paddle.height))

    local dx = ball.x - closestX
    local dy = ball.y - closestY
    local distanceSquared = dx * dx + dy * dy

    if distanceSquared < ball.radius * ball.radius then
        -- Compute normal vector
        local nx, ny = dx, dy
        if nx == 0 and ny == 0 then
            -- Edge case: center inside paddle — use fallback
            nx = (ball.vx > 0) and -1 or 1
            ny = 0
        end

        -- Reflect velocity
        ball.vx, ball.vy = reflect(ball.vx, ball.vy, nx, ny)

        -- Small reposition to avoid sticking
        ball.x = ball.x + ball.vx * 0.01
        ball.y = ball.y + ball.vy * 0.01
    end
end

return physics
