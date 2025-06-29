-- render.lua

local Render = {}

function Render.centerLine()
    for y = 0, SCREEN_HEIGHT, BALL_SIZE * 2 do
        love.graphics.rectangle("fill",
            (SCREEN_WIDTH - BALL_SIZE) / 2, y,
            BALL_SIZE, BALL_SIZE)
    end
end

function Render.score(left, right)
    love.graphics.print(tostring(left), SCREEN_WIDTH/2 - 48, 16)
    love.graphics.print(tostring(right), SCREEN_WIDTH/2 + 32, 16)
end

return Render
