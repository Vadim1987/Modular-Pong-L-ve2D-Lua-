-- main.lua
-- The conductor. Orchestrates all modules and game flow.

local C = require 'constants'
local Paddle = require 'paddle'
local Ball = require 'ball'
local AI = require 'ai'
local Render = require 'render'
local Score = require 'score'

local player, ai, ball
local score = {player = 0, ai = 0}
local gameOver = false
local aiStrategy = 1 -- Current AI strategy index

function love.load()
    love.window.setMode(C.WINDOW_WIDTH, C.WINDOW_HEIGHT)
    love.graphics.setBackgroundColor(0, 0, 0)
    -- Initialize paddles and ball in the center
    player = Paddle.new(C.PADDLE_MARGIN, C.WINDOW_HEIGHT/2 - C.PADDLE_HEIGHT/2, 'player')
    ai = Paddle.new(C.WINDOW_WIDTH - C.PADDLE_MARGIN - C.PADDLE_WIDTH, C.WINDOW_HEIGHT/2 - C.PADDLE_HEIGHT/2, 'ai')
    ball = Ball.new(C.WINDOW_WIDTH/2 - C.BALL_SIZE/2, C.WINDOW_HEIGHT/2 - C.BALL_SIZE/2)
end

function love.update(dt)
    if gameOver then return end

    player:update(dt)
    -- Call selected AI strategy as a pure function
    AI.strategies[aiStrategy](ai, ball, dt, player)
    ai:update(dt)

    ball:update(dt, player, ai)
    local scored = ball:checkScore()
    if scored then
        score[scored] = score[scored] + 1
        if score[scored] == C.SCORE_TO_WIN then
            gameOver = true
        end
        ball:reset()
    end
end

function love.draw()
    Render.drawField()
    Render.drawNet()
    player:draw()
    ai:draw()
    ball:draw()
    Score.draw(score)
    if gameOver then
        Render.drawGameOver(score)
    end
end

function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
    if gameOver and key == 'space' then
        -- Reset the game
        score = {player = 0, ai = 0}
        gameOver = false
        ball:reset()
    end
    if key == 'tab' then
        -- Change AI strategy on the fly
        aiStrategy = (aiStrategy % #AI.strategies) + 1
    end
end
