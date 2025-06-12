-- ball.lua
local C = require "constants"

local Ball = {}
Ball.__index = Ball

function Ball:new()
    local dir = math.random(0, 1) == 0 and -1 or 1
    return setmetatable({
        x = C.WINDOW_WIDTH / 2 - C.BALL_SIZE / 2,
        y = C.WINDOW_HEIGHT / 2 - C.BALL_SIZE / 2,
        vx = C.BALL_SPEED * dir,
        vy = (math.random() * 2 - 1) * C.BALL_SPEED * 0.75
    }, Ball)
end

function Ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Bounce off top and bottom
    if self.y < 0 then
        self.y = 0
        self.vy = -self.vy
    elseif self.y + C.BALL_SIZE > C.WINDOW_HEIGHT then
        self.y = C.WINDOW_HEIGHT - C.BALL_SIZE
        self.vy = -self.vy
    end
end

function Ball:draw()
    love.graphics.rectangle("fill", self.x, self.y, C.BALL_SIZE, C.BALL_SIZE)
end

function Ball:reset()
    local b = Ball:new()
    self.x, self.y, self.vx, self.vy = b.x, b.y, b.vx, b.vy
end

return Ball
