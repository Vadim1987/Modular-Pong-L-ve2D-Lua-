-- ball.lua
local Ball = {}
Ball.__index = Ball

function Ball.new()
    local self = setmetatable({}, Ball)
    self.radius = BALL_RADIUS
    self:reset()
    return self
end

function Ball:reset()
    self.x = SCREEN_WIDTH / 2
    self.y = SCREEN_HEIGHT / 2
    self.vx = BALL_SPEED_X * (math.random(2) == 1 and 1 or -1)
    self.vy = BALL_SPEED_Y * (math.random(2) == 1 and 1 or -1)
end

function Ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Bounce off top and bottom
    if self.y - self.radius < 0 then
        self.y = self.radius
        self.vy = -self.vy
    elseif self.y + self.radius > SCREEN_HEIGHT then
        self.y = SCREEN_HEIGHT - self.radius
        self.vy = -self.vy
    end
end

function Ball:draw()
    love.graphics.setColor(COLOR_FOREGROUND)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
