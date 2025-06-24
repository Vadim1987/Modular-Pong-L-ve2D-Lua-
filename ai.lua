-- ai.lua
-- Modular AI strategies for the right paddle (computer side).
-- Now includes a "manual" strategy for two-player mode (arrow keys).

local C = require 'constants'
local AI = {}

AI.strategies = {
    -- 1. "Perfect" AI — always follows the ball
    function(self, ball, dt, player)
        if ball.y + ball.size/2 < self.y + self.height/2 then
            self.vy = -self.speed
        elseif ball.y + ball.size/2 > self.y + self.height/2 then
            self.vy = self.speed
        else
            self.vy = 0
        end
    end,
    -- 2. "Lazy" — only reacts if the ball is close horizontally
    function(self, ball, dt, player)
        if math.abs(ball.x - self.x) < 200 then
            if ball.y + ball.size/2 < self.y + self.height/2 then
                self.vy = -self.speed/1.5
            elseif ball.y + ball.size/2 > self.y + self.height/2 then
                self.vy = self.speed/1.5
            else
                self.vy = 0
            end
        else
            self.vy = 0
        end
    end,
    -- 3. "Random error" — sometimes ignores the ball
    function(self, ball, dt, player)
        if math.random() < 0.9 then
            if ball.y + ball.size/2 < self.y + self.height/2 then
                self.vy = -self.speed
            elseif ball.y + ball.size/2 > self.y + self.height/2 then
                self.vy = self.speed
            else
                self.vy = 0
            end
        else
            self.vy = 0
        end
    end,
    -- 4. "Naive mimic" — copies the player's paddle Y
    function(self, ball, dt, player)
        if player.y + player.height/2 < self.y + self.height/2 then
            self.vy = -self.speed
        elseif player.y + player.height/2 > self.y + self.height/2 then
            self.vy = self.speed
        else
            self.vy = 0
        end
    end,
    -- 5. "Manual" — two-player mode (arrow keys for right paddle)
    function(self, ball, dt, player)
        -- Manual control: up/down arrows for right paddle
        if love.keyboard.isDown('up') then
            self.vy = -self.speed
        elseif love.keyboard.isDown('down') then
            self.vy = self.speed
        else
            self.vy = 0
        end
    end,

-- 6. "Clever predictor" — follows predicted intersection with AI's half
function(self, ball, dt, player)
    -- Predict where the ball will cross AI paddle's x
    local future_y = ball.y + (C.PADDLE_MAX_X_RIGHT - ball.x) * (ball.vy / (ball.vx or 0.01))
    if future_y < self.y + self.height / 2 then self.vy = -self.speed
    elseif future_y > self.y + self.height / 2 then self.vy =  self.speed
    else self.vy = 0 end

    -- Move horizontally to keep paddle between center and allowed rightmost
    if ball.vx > 0 then
        if ball.y > self.y + self.height/2 then
            self.vx = self.hspeed
        elseif ball.y < self.y + self.height/2 then
            self.vx = -self.hspeed
        else
            self.vx = 0
        end
    else
        -- Return to center of AI's allowed area when ball is not coming
        if self.x > (C.PADDLE_MIN_X_RIGHT + C.PADDLE_MAX_X_RIGHT)/2 then
            self.vx = -self.hspeed
        else
            self.vx = self.hspeed
        end
    end
end

}

return AI
