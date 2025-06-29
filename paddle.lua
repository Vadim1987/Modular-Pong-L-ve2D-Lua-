-- paddle.lua

local Paddle = {}
Paddle.__index = Paddle

function Paddle.new(side)
    local x = side == "left" and PADDLE_OFFSET_X or (SCREEN_WIDTH - PADDLE_OFFSET_X - PADDLE_WIDTH)
    return setmetatable({
        x = x,
        y = (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2,
        vy = 0,
        side = side
    }, Paddle)
end

function Paddle:update(dt, control)
   if control == "player" then
    local move = 0
    if self.side == "left" then
        if love.keyboard.isDown(LEFT_PADDLE_UP) then move = -1 end
        if love.keyboard.isDown(LEFT_PADDLE_DOWN) then move = move + 1 end
    else
        if love.keyboard.isDown(RIGHT_PADDLE_UP) then move = -1 end
        if love.keyboard.isDown(RIGHT_PADDLE_DOWN) then move = move + 1 end
    end
    self.vy = move * PADDLE_SPEED
    self.y = math.max(0, math.min(SCREEN_HEIGHT - PADDLE_HEIGHT, self.y + self.vy * dt))
    elseif type(control) == "function" then
        -- AI control, expects function: (paddle, ball, dt) -> newY
        self.y, self.vy = control(self, dt)
    end
end

function Paddle:draw()
    love.graphics.rectangle("fill", self.x, self.y, PADDLE_WIDTH, PADDLE_HEIGHT)
end

return Paddle
