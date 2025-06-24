-- ai.lua
-- Pure, modular AI strategies for the right paddle (the computer's side).
-- Plug and play. Some are intentionally "bad", some perfect. Pick your poison.

local C = require 'constants'
local AI = {}

AI.strategies = {
    -- 1. "Perfect" AI — always follows the ball. No mercy.
    function(self, ball, dt, player)
        if ball.y + ball.size/2 < self.y + self.height/2 then
            self.vy = -self.speed
        elseif ball.y + ball.size/2 > self.y + self.height/2 then
            self.vy = self.speed
        else
            self.vy = 0
        end
    end,
    -- 2. "Lazy" — only reacts if ball is close horizontally.
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
    -- 3. "Random error" — sometimes just doesn't care.
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
    -- 4. "Naive mimic" — tries to follow the player's paddle position.
    function(self, ball, dt, player)
        if player.y + player.height/2 < self.y + self.height/2 then
            self.vy = -self.speed
        elseif player.y + player.height/2 > self.y + self.height/2 then
            self.vy = self.speed
        else
            self.vy = 0
        end
    end,
}

return AI
