-- ball.lua
-- The puck: movement, collisions, scoring logic, resets.

local C = require 'constants'

local Ball = {}
Ball.__index = Ball

function Ball.new(x, y)
    local self = setmetatable({}, Ball)
    self.x = x
    self.y = y
    self.size = C.BALL_SIZE
    self.speed = C.BALL_SPEED
    -- Initial velocity: random direction, always full speed horizontally
    self.vx = self.speed * (math.random() < 0.5 and -1 or 1)
    self.vy = self.speed * (math.random() * 2 - 1)
    return self
end

function Ball:reset()
    -- Resets the ball to the center, random direction
    self.x = C.WINDOW_WIDTH/2 - self.size/2
    self.y = C.WINDOW_HEIGHT/2 - self.size/2
    self.vx = self.speed * (math.random() < 0.5 and -1 or 1)
    self.vy = self.speed * (math.random() * 2 - 1)
end

function Ball:update(dt, player, ai)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Bounce off top/bottom
    if self.y < 0 then
        self.y = 0
        self.vy = -self.vy
    elseif self.y + self.size > C.WINDOW_HEIGHT then
        self.y = C.WINDOW_HEIGHT - self.size
        self.vy = -self.vy
    end

    -- Collide with paddles: reverse X and (optionally) add some paddle velocity to Y
    if self:collides(player) then
        self.x = player.x + player.width
        self.vx = -self.vx
        self.vy = self.vy + 0.3 * player.vy
    elseif self:collides(ai) then
        self.x = ai.x - self.size
        self.vx = -self.vx
        self.vy = self.vy + 0.3 * ai.vy
    end
end

function Ball:collides(paddle)
    -- Simple AABB collision check
    return self.x < paddle.x + paddle.width and self.x + self.size > paddle.x and
           self.y < paddle.y + paddle.height and self.y + self.size > paddle.y
end

function Ball:checkScore()
    -- Returns 'ai' if left wall hit, 'player' if right wall hit
    if self.x < 0 then return 'ai' end
    if self.x + self.size > C.WINDOW_WIDTH then return 'player' end
    return nil
end

function Ball:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end

return Ball



            
           



