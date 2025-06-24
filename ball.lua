-- ball.lua
-- Now with a circular puck and real tangent reflection physics!

local C = require 'constants'

local Ball = {}
Ball.__index = Ball

function Ball.new(x, y)
    local self = setmetatable({}, Ball)
    self.x = x
    self.y = y
    self.radius = C.BALL_RADIUS
    self.speed = C.BALL_SPEED
    -- Random initial direction
    self.vx = self.speed * (math.random() < 0.5 and -1 or 1)
    self.vy = self.speed * (math.random() * 2 - 1)
    return self
end

function Ball:reset()
    self.x = C.WINDOW_WIDTH/2
    self.y = C.WINDOW_HEIGHT/2
    self.vx = self.speed * (math.random() < 0.5 and -1 or 1)
    self.vy = self.speed * (math.random() * 2 - 1)
end

function Ball:update(dt, player, ai)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Bounce off top/bottom walls
    if self.y - self.radius < 0 then
        self.y = self.radius
        self.vy = -self.vy
    elseif self.y + self.radius > C.WINDOW_HEIGHT then
        self.y = C.WINDOW_HEIGHT - self.radius
        self.vy = -self.vy
    end

    -- Collisions with paddles (new logic: circle-rectangle collision + tangent reflection)
    self:checkPaddleCollision(player)
    self:checkPaddleCollision(ai)
end

function Ball:checkPaddleCollision(paddle)
    -- Closest point on paddle to center of ball
    local closestX = math.max(paddle.x, math.min(self.x, paddle.x + paddle.width))
    local closestY = math.max(paddle.y, math.min(self.y, paddle.y + paddle.height))
    local dx = self.x - closestX
    local dy = self.y - closestY
    local distance = math.sqrt(dx * dx + dy * dy)
    if distance < self.radius then
        -- Determine where collision happened
        local hitVerticalSide = (self.y > paddle.y and self.y < paddle.y + paddle.height)
        local hitHorizontalSide = (self.x > paddle.x and self.x < paddle.x + paddle.width)
        if hitVerticalSide then
            -- Bounce horizontally
            if self.vx * (self.x - (paddle.x + paddle.width/2)) < 0 then
                self.x = (self.x < paddle.x + paddle.width/2) and (paddle.x - self.radius) or (paddle.x + paddle.width + self.radius)
                self.vx = -self.vx
                self.vy = self.vy + 0.3 * paddle.vy
                -- Added both paddle velocities
                self.vx = self.vx + 0.3 * paddle.vx
                self.vy = self.vy + 0.3 * paddle.vy
            end
        elseif hitHorizontalSide then
            -- Bounce vertically
            if self.vy * (self.y - (paddle.y + paddle.height/2)) < 0 then
                self.y = (self.y < paddle.y + paddle.height/2) and (paddle.y - self.radius) or (paddle.y + paddle.height + self.radius)
                self.vy = -self.vy + 0.3 * paddle.vx
                self.vx = self.vx + 0.3 * paddle.vy
            end
        else
            -- Corner: reflect about normal (tangent)
            local norm = math.sqrt(dx*dx + dy*dy)
            if norm == 0 then norm = 1 end
            dx = dx / norm
            dy = dy / norm
            local dot = self.vx * dx + self.vy * dy
            self.vx = self.vx - 2 * dot * dx
            self.vy = self.vy - 2 * dot * dy
             -- Added both paddle velocities
            self.vx = self.vx + 0.3 * paddle.vx
            self.vy = self.vy + 0.3 * paddle.vy
            -- Move ball just outside the paddle
            self.x = closestX + dx * (self.radius + 0.1)
            self.y = closestY + dy * (self.radius + 0.1)
        end
    end
end

function Ball:checkScore()
    if self.x - self.radius < 0 then return 'ai' end
    if self.x + self.radius > C.WINDOW_WIDTH then return 'player' end
    return nil
end

function Ball:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Ball




