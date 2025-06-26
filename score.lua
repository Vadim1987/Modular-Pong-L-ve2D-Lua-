-- score.lua
-- Handles score display. Keeps things dry and modular.

local C = require 'constants'

local Score = {}

function Score.draw(score)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont(C.SCORE_FONT_SIZE))
    love.graphics.print(score.player, C.WINDOW_WIDTH/2 - 50, 20)
    love.graphics.print(score.ai, C.WINDOW_WIDTH/2 + 30, 20)
end

return Score

