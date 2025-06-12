-- main.lua
local C = require "constants"
local Paddle = require "paddle"
local Ball = require "ball"
local ai = require "ai"
local collision = require "collision"

local leftPaddle, rightPaddle, ball
local leftScore, rightScore
local gameOver
local scoreFont
local aiStrategy
local collisionStrategy

function love.load()
    math.randomseed(os.time())
    love.window.setMode(C.WINDOW_WIDTH, C.WINDOW_HEIGHT)
    love.graphics.setBackgroundColor(0, 0, 0)
    scoreFont = love.graphics.newFont(C.SCORE_FONT_SIZE)
    leftPaddle = Paddle:new(C.PADDLE_MARGIN, C.WINDOW_HEIGHT/2 - C.PADDLE_HEIGHT/2)
    rightPaddle = Paddle:new(C.WINDOW_WIDTH - C.PADDLE_MARGIN - C.PADDLE_WIDTH, C.WINDOW_HEIGHT/2 - C.PADDLE_HEIGHT/2)
    ball = Ball:new()
    leftScore = 0
    rightScore = 0
    gameOver = false
    aiStrategy = ai.STRATEGIES[1]    -- Switch AI strategy (1-4)
    collisionStrategy = collision.STRATEGIES[1] -- Switch collision logic (1-2)
end

function love.update(dt)
    if gameOver then return end

    -- Player: Q/A or mouse
    local up = love.keyboard.isDown("q") or (love.mouse.isDown(1) and love.mouse.getY() < leftPaddle.y)
    local down = love.keyboard.isDown("a") or (love.mouse.isDown(1) and love.mouse.getY() > leftPaddle.y + C.PADDLE_HEIGHT)
    leftPaddle:update(dt, up, down)

    -- AI
    local ai_up, ai_down = aiStrategy(rightPaddle, ball)
    rightPaddle:update(dt, ai_up, ai_down)

    ball:update(dt)

    -- Left paddle collision
    if checkCollision(ball, leftPaddle) and ball.vx < 0 then
        collisionStrategy(ball, leftPaddle)
        ball.x = leftPaddle.x + C.PADDLE_WIDTH
    end
    -- Right paddle collision
    if checkCollision(ball, rightPaddle) and ball.vx > 0 then
        collisionStrategy(ball, rightPaddle)
        ball.x = rightPaddle.x - C.BALL_SIZE
    end

    -- Score!
    if ball.x < 0 then
        rightScore = rightScore + 1
        resetOrGameOver()
    elseif ball.x + C.BALL_SIZE > C.WINDOW_WIDTH then
        leftScore = leftScore + 1
        resetOrGameOver()
    end
end

function resetOrGameOver()
    if leftScore == C.SCORE_TO_WIN or rightScore == C.SCORE_TO_WIN then
        gameOver = true
    else
        ball:reset()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "space" and gameOver then
        leftScore, rightScore = 0, 0
        ball:reset()
        gameOver = false
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)
    drawNet()
    leftPaddle:draw()
    rightPaddle:draw()
    ball:draw()
    drawScore()
    if gameOver then
        love.graphics.setFont(scoreFont)
        local msg = leftScore == C.SCORE_TO_WIN and "PLAYER WINS!" or "COMPUTER WINS!"
        love.graphics.printf(msg, 0, C.WINDOW_HEIGHT/2 - 50, C.WINDOW_WIDTH, "center")
        love.graphics.printf("Press SPACE to restart", 0, C.WINDOW_HEIGHT/2, C.WINDOW_WIDTH, "center")
    end
end

function drawNet()
    for y = 0, C.WINDOW_HEIGHT, C.NET_UNIT_SIZE+C.NET_GAP_SIZE do
        love.graphics.rectangle("fill",
            C.WINDOW_WIDTH/2 - C.NET_UNIT_SIZE/2,
            y,
            C.NET_UNIT_SIZE,
            C.NET_UNIT_SIZE
        )
    end
end

function drawScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(leftScore, C.WINDOW_WIDTH/2 - 60, 30)
    love.graphics.print(rightScore, C.WINDOW_WIDTH/2 + 40, 30)
end

function checkCollision(ball, paddle)
    return ball.x < paddle.x + C.PADDLE_WIDTH and
           ball.x + C.BALL_SIZE > paddle.x and
           ball.y < paddle.y + C.PADDLE_HEIGHT and
           ball.y + C.BALL_SIZE > paddle.y
end
