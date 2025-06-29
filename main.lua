-- main.lua
require "constants"
local Game = require "game"

function love.load()
    love.graphics.setBackgroundColor(COLOR_BACKGROUND)
    Game.load()
end

function love.update(dt)
    Game.update(dt)
end

function love.draw()
    Game.draw()
end

function love.keypressed(key)
    Game.keypressed(key)
end

 
       

   
