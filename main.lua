-- main.lua

require "constants"
local Paddle = require "paddle"
local Ball = require "ball"
local AI = require "ai"
local Collision = require "collision"
local Render = require "render"

local leftPaddle, rightPaddle, ball
local leftScore, rightScore
local gameOver = false
local collisionStrategy

local rightPaddleControl = "player"  -- "ai" or "player"

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setBackgroundColor(COLOR_BG)
    leftPaddle = Paddle.new("left")
    rightPaddle = Paddle.new("right")
    ball = Ball.new()
    leftScore, rightScore = 0, 0
    gameOver = false
    collisionStrategy = Collision.add_paddle_velocity -- always add paddle velocity
    rightPaddleControl = "player"
end

function resetBall()
    ball = Ball.new()
end

function love.update(dt)
    if gameOver then return end

    leftPaddle:update(dt, "player")
    if rightPaddleControl == "ai" then
        rightPaddle:update(dt, function(p, dt) return AI.smart(p, ball, dt) end)
    else
        rightPaddle:update(dt, "player")
    end

    ball:update(dt)

    -- Ball collision with top/bottom
    if ball.y - BALL_RADIUS <= 0 then
        ball.y = BALL_RADIUS
        ball.vy = -ball.vy
    end
    if ball.y + BALL_RADIUS >= SCREEN_HEIGHT then
        ball.y = SCREEN_HEIGHT - BALL_RADIUS
        ball.vy = -ball.vy
    end

    -- Ball collision with paddles
    collisionStrategy(ball, leftPaddle)
    collisionStrategy(ball, rightPaddle)

    -- Scoring
    if ball.x - BALL_RADIUS < 0 then
        rightScore = rightScore + 1
        if rightScore >= WINNING_SCORE then gameOver = true end
        resetBall()
    elseif ball.x + BALL_RADIUS > SCREEN_WIDTH then
        leftScore = leftScore + 1
        if leftScore >= WINNING_SCORE then gameOver = true end
        resetBall()
    end
end

function love.draw()
    love.graphics.setColor(COLOR_FG)
    Render.centerLine()
    leftPaddle:draw()
    rightPaddle:draw()
    ball:draw()
    Render.score(leftScore, rightScore)
    if gameOver then
        love.graphics.print("Game Over", SCREEN_WIDTH/2-32, SCREEN_HEIGHT/2-10)
    else
        love.graphics.print(
            "Left: WASD   Right: Arrows  (Press R for AI on right)",
            32, SCREEN_HEIGHT - 24)
    end
end

function love.keypressed(key)
    if key == "r" then
        rightPaddleControl = (rightPaddleControl == "ai") and "player" or "ai"
    end
end

 
  
    
