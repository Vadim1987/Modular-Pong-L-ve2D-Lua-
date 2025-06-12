-- paddle.lua
local C = require "constants"

local Paddle = {}
Paddle.__index = Paddle

function Paddle:new(x, y)
    return setmetatable({
        x = x,
        y = y,
        vy = 0
    }, Paddle)
end

function Paddle:update(dt, up, down)
    self.vy = 0
    if up then
        self.y = math.max(0, self.y - C.PADDLE_SPEED * dt)
        self.vy = -C.PADDLE_SPEED
    elseif down then
        self.y = math.min(C.WINDOW_HEIGHT - C.PADDLE_HEIGHT, self.y + C.PADDLE_SPEED * dt)
        self.vy = C.PADDLE_SPEED
    end
end

function Paddle:draw()
    love.graphics.rectangle("fill", self.x, self.y, C.PADDLE_WIDTH, C.PADDLE_HEIGHT)
end

return Paddle
