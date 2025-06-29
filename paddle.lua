-- paddle.lua

local Paddle = {}
Paddle.__index = Paddle

function Paddle.new(side)
    local x = side == "left" and LEFT_PADDLE_MIN_X or RIGHT_PADDLE_MAX_X
    return setmetatable({
        x = x,
        y = (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2,
        vx = 0,
        vy = 0,
        side = side
    }, Paddle)
end

function Paddle:update(dt, control)
    local moveY, moveX = 0, 0
    if control == "player" then
        if self.side == "left" then
            if love.keyboard.isDown(LEFT_PADDLE_UP) then moveY = -1 end
            if love.keyboard.isDown(LEFT_PADDLE_DOWN) then moveY = moveY + 1 end
            if love.keyboard.isDown(LEFT_PADDLE_LEFT) then moveX = -1 end
            if love.keyboard.isDown(LEFT_PADDLE_RIGHT) then moveX = moveX + 1 end
        else
            if love.keyboard.isDown(RIGHT_PADDLE_UP) then moveY = -1 end
            if love.keyboard.isDown(RIGHT_PADDLE_DOWN) then moveY = moveY + 1 end
            if love.keyboard.isDown(RIGHT_PADDLE_LEFT) then moveX = -1 end
            if love.keyboard.isDown(RIGHT_PADDLE_RIGHT) then moveX = moveX + 1 end
        end
    elseif type(control) == "function" then
        self.y, self.vy, self.x, self.vx = control(self, dt)
        return
    end

    self.vy = moveY * PADDLE_SPEED
    self.y = math.max(0, math.min(SCREEN_HEIGHT - PADDLE_HEIGHT, self.y + self.vy * dt))

    local minX, maxX
    if self.side == "left" then
        minX, maxX = LEFT_PADDLE_MIN_X, LEFT_PADDLE_MAX_X
    else
        minX, maxX = RIGHT_PADDLE_MIN_X, RIGHT_PADDLE_MAX_X
    end
    self.vx = moveX * PADDLE_SPEED
    self.x = math.max(minX, math.min(maxX, self.x + self.vx * dt))
end

function Paddle:draw()
    love.graphics.rectangle("fill", self.x, self.y, PADDLE_WIDTH, PADDLE_HEIGHT)
end

return Paddle

            


