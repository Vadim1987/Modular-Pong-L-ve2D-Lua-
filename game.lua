local Paddle = require "paddle"
local Ball = require "ball"

local Game = {}

-- Declare paddles and ball
local player, computer, ball

function Game.load()
    -- Create player paddles and the ball
    player = Paddle.new(LEFT_PADDLE_X, SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2, true)
    computer = Paddle.new(RIGHT_PADDLE_X, SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2, false)
    ball = Ball.new()
end
function Game.update(dt)
    -- Update left paddle (player)
    player:update(dt)
    local physics = require "physics"

physics.checkPaddleCollision(ball, player)
physics.checkPaddleCollision(ball, computer)


    -- Update right paddle depending on mode
    if MANUAL_OPPONENT then
        -- Manual mode: right paddle is player 2
        computer:update(dt)
    else
        -- TODO: AI strategy goes here
    end

    -- Update ball position and physics
    ball:update(dt)
    
    -- TODO: handle collisions, scoring, and game over
end
function Game.keypressed(key)
    -- Player 1 controls
    if key == KEY_UP then player:moveUp() end
    if key == KEY_DOWN then player:moveDown() end

    -- Player 2 controls (if manual opponent is enabled)
    if MANUAL_OPPONENT then
        if key == KEY_RIGHT_UP then computer:moveUp() end
        if key == KEY_RIGHT_DOWN then computer:moveDown() end
    end
end
function love.keyreleased(key)
    -- Stop movement for player 1
    if key == KEY_UP or key == KEY_DOWN then
        player:stop()
    end

    -- Stop movement for player 2 (manual mode only)
    if MANUAL_OPPONENT and (key == KEY_RIGHT_UP or key == KEY_RIGHT_DOWN) then
        computer:stop()
    end
end

