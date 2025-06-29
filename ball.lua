-- ball.lua

local Ball = {}
Ball.__index = Ball

function Ball.new()
    return setmetatable({
        x = (SCREEN_WIDTH - BALL_SIZE) / 2,
        y = (SCREEN_HEIGHT - BALL_SIZE) / 2,
        vx = BALL_SPEED_X * (math.random() > 0.5 and 1 or -1),
        vy = BALL_SPEED_Y * (math.random() > 0.5 and 1 or -1)
    }, Ball)
end

function Ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Ball:draw()
    love.graphics.rectangle("fill", self.x, self.y, BALL_SIZE, BALL_SIZE)
end

return Ball
