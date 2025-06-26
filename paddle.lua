-- paddle.lua
-- Paddle logic for both player and AI. Movement, position, rendering.

local C = require 'constants'
local Paddle = {}
Paddle.__index = Paddle

function Paddle.new(x, y, role)
    local self = setmetatable({}, Paddle)
    self.x = x
    self.y = y
    self.role = role
    self.width = C.PADDLE_WIDTH
    self.height = C.PADDLE_HEIGHT
    self.speed = C.PADDLE_SPEED
    self.vy = 0 -- vertical speed
    return self
end

function Paddle:update(dt)
    -- Player uses Q/A keys (classic, no nostalgia spared)
    if self.role == 'player' then
        if love.keyboard.isDown('q') then
            self.vy = -self.speed
        elseif love.keyboard.isDown('a') then
            self.vy = self.speed
        else
            self.vy = 0
        end
        -- Optional: mouse control (uncomment if you want it)
        -- self.y = math.max(0, math.min(C.WINDOW_HEIGHT - self.height, love.mouse.getY() - self.height / 2))
    end
    -- Update position, clamp inside window
    self.y = self.y + self.vy * dt
    self.y = math.max(0, math.min(C.WINDOW_HEIGHT - self.height, self.y))
end

function Paddle:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Paddle

    

 
   
