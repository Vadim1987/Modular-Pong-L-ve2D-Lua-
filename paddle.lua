-- paddle.lua
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
    self.hspeed = C.PADDLE_HSPEED
    self.vx = 0 -- horizontal velocity
    self.vy = 0 -- vertical velocity
    return self
end

function Paddle:update(dt)
    self.vx, self.vy = 0, 0
    if self.role == 'player' then
        if love.keyboard.isDown('w') then self.vy = -self.speed end
        if love.keyboard.isDown('s') then self.vy =  self.speed end
        if love.keyboard.isDown('a') then self.vx = -self.hspeed end
        if love.keyboard.isDown('d') then self.vx =  self.hspeed end
        -- Clamp movement to allowed area
        self.x = math.max(C.PADDLE_MIN_X_LEFT, math.min(C.PADDLE_MAX_X_LEFT, self.x + self.vx * dt))
        self.y = math.max(0, math.min(C.WINDOW_HEIGHT - self.height, self.y + self.vy * dt))
    elseif self.role == 'ai' then
        -- AI: vx/vy should be set by strategy
        self.x = math.max(C.PADDLE_MIN_X_RIGHT, math.min(C.PADDLE_MAX_X_RIGHT, self.x + self.vx * dt))
        self.y = math.max(0, math.min(C.WINDOW_HEIGHT - self.height, self.y + self.vy * dt))
    end
end

function Paddle:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Paddle

 
   
