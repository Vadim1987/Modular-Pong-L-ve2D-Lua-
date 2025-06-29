-- paddle.lua
local Paddle = {}
Paddle.__index = Paddle

function Paddle.new(x, y, isPlayer)
    local self = setmetatable({}, Paddle)
    self.x = x
    self.y = y
    self.width = PADDLE_WIDTH
    self.height = PADDLE_HEIGHT
    self.speed = PADDLE_SPEED
    self.isPlayer = isPlayer
    self.dy = 0 -- вертикальная скорость
    return self
end

function Paddle:update(dt)
    self.y = self.y + self.dy * dt

   -- do not go beyond the screen boundaries
    if self.y < 0 then self.y = 0 end
    if self.y + self.height > SCREEN_HEIGHT then
        self.y = SCREEN_HEIGHT - self.height
    end
end

function Paddle:draw()
    love.graphics.setColor(COLOR_FOREGROUND)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Paddle:moveUp()
    self.dy = -self.speed
end

function Paddle:moveDown()
    self.dy = self.speed
end

function Paddle:stop()
    self.dy = 0
end

return Paddle




 
   
