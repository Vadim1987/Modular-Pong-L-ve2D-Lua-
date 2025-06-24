-- render.lua
-- Handles all field and UI drawing. Keeps main.lua pretty.

local C = require 'constants'

local Render = {}

function Render.drawField()
    -- The background is already black by default, but you could add effects here
end

function Render.drawNet()
    -- Dotted vertical line (net) in the middle of the field
    for y = 0, C.WINDOW_HEIGHT, C.NET_UNIT_SIZE + C.NET_GAP_SIZE do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',
            C.WINDOW_WIDTH/2 - C.NET_UNIT_SIZE/2, y,
            C.NET_UNIT_SIZE, C.NET_UNIT_SIZE)
    end
end

function Render.drawGameOver(score)
    love.graphics.setColor(1,1,1)
    local winner = score.player > score.ai and "PLAYER" or "AI"
    love.graphics.printf("GAME OVER! "..winner.." WINS",
        0, C.WINDOW_HEIGHT/2-40, C.WINDOW_WIDTH, 'center')
    love.graphics.printf("Press SPACE to restart", 0, C.WINDOW_HEIGHT/2, C.WINDOW_WIDTH, 'center')
end

return Render
