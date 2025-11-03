-- main.lua


require "constants"


-- screen helpers --

WW = 0
WH = 0

function cache_wh()
  WW = love.graphics.getWidth()
  WH = love.graphics.getHeight()
end

function W()
  return WW
end

function H()
  return WH
end

function resized()
  local cw = love.graphics.getWidth()
  local ch = love.graphics.getHeight()
  return cw ~= WW or ch ~= WH
end

function cx(s)
  return W() / 2 - s / 2
end

function cy(s)
  return H() / 2 - s / 2
end


-- timing (fixed step) --
USE_FIXED   = true
FIXED_DT    = 1 / 60
MAX_STEPS   = 5
TIME_T      = 0
ACC         = 0
SPEED_SCALE = 1.5


-- global state and resources --

mouseEnabled = false
INited = false

S = {
  player = {
    x = PADDLE_OFFSET_X,
    y = 0,
    w = PADDLE_WIDTH,
    h = PADDLE_HEIGHT,
    dy = 0
  },
  opp = {
    x = 0,
    y = 0,
    w = PADDLE_WIDTH,
    h = PADDLE_HEIGHT,
    dy = 0
  },
  ball = {
    x = 0,
    y = 0,
    dx = BALL_SPEED_X,
    dy = BALL_SPEED_Y,
    size = BALL_SIZE
  },
  playerScore = 0,
  oppScore    = 0,
  state       = "start"
}

FONT          = nil
TXT_START     = nil
TXT_OVER      = nil
TXT_L         = nil
TXT_R         = nil
TXT_HELP1     = nil
TXT_HELP2     = nil
CENTER_CANVAS = nil


-- layout / build --

function layout()
  S.player.y = cy(PADDLE_HEIGHT)
  S.opp.x = W() - PADDLE_OFFSET_X - PADDLE_WIDTH
  S.opp.y = cy(PADDLE_HEIGHT)
  S.ball.x = cx(BALL_SIZE)
  S.ball.y = cy(BALL_SIZE)
end

function draw_center_line()
  local x = math.floor(W() / 2 - 2 + 0.5)
  local step = BALL_SIZE * 2
  local y = 0
  while y < H() do
    love.graphics.rectangle(
      "fill", x, y, 4, BALL_SIZE
    )
    y = y + step
  end
end

function build_center_canvas()
  if CENTER_CANVAS then
    CENTER_CANVAS:release()
  end
  CENTER_CANVAS = love.graphics.newCanvas(
    W(), H()
  )
  love.graphics.setCanvas(CENTER_CANVAS)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setColor(COLOR_FG)
  draw_center_line()
  love.graphics.setCanvas()
end

function build_static_texts()
  FONT = love.graphics.getFont()
  TXT_START = love.graphics.newText(
    FONT, "Press Space to Start"
  )
  TXT_OVER = love.graphics.newText(
    FONT, "Game Over - Space to Restart"
  )
  TXT_HELP1 = love.graphics.newText(
    FONT, "Left: Q/A/Mouse | Right: Arrows"
  )
  TXT_HELP2 = love.graphics.newText(
    FONT, "Space: Start | Esc: Quit"
  )
end

function rebuild_score_texts()
  if TXT_L then TXT_L:release() end
  if TXT_R then TXT_R:release() end
  TXT_L = love.graphics.newText(
    FONT, tostring(S.playerScore)
  )
  TXT_R = love.graphics.newText(
    FONT, tostring(S.oppScore)
  )
end


-- init / ensure --

function do_init()
  cache_wh()
  layout()
  build_center_canvas()
  build_static_texts()
  rebuild_score_texts()
  love.mouse.setRelativeMode(true)
  mouseEnabled = true
  TIME_T = love.timer.getTime()
  INited = true
end

function ensure_init()
  if not INited then
    do_init()
  end
  if resized() then
    cache_wh()
    layout()
    build_center_canvas()
  end
end


-- paddle helpers --

function clamp_paddle(p)
  if p.y < 0 then
    p.y = 0
    p.dy = 0
  end
  local maxY = H() - p.h
  if p.y > maxY then
    p.y = maxY
    p.dy = 0
  end
end

function move_paddle(p, dir, dt)
  p.dy = PADDLE_SPEED * dir
  p.y = p.y + p.dy * dt
  clamp_paddle(p)
end


-- input --

function love.mousemoved(x, y, dx, dy, istouch)
  if not mouseEnabled then return end
  if istouch then return end
  if S.state ~= "play" then return end
  local p = S.player
  p.y = p.y + dy * MOUSE_SENSITIVITY
  clamp_paddle(p)
end

function love.keypressed(k)
  if k == "space" then
    if S.state == "start" then
      S.state = "play"
      reset_ball()
    elseif S.state == "gameover" then
      S.playerScore = 0
      S.oppScore = 0
      rebuild_score_texts()
      layout()
      S.state = "start"
    end
  elseif k == "escape" then
    love.event.quit()
  end
end


-- ball physics --

function move_ball(b, dt)
  b.x = b.x + b.dx * dt
  b.y = b.y + b.dy * dt
end

function bounce_walls(b)
  if b.y <= 0 then
    b.y = 0
    b.dy = -b.dy
  end
  local maxY = H() - b.size
  if b.y >= maxY then
    b.y = maxY
    b.dy = -b.dy
  end
end

function collide(b, p, off)
  local hx1 = b.x < p.x + p.w
  local hx2 = b.x + b.size > p.x
  local hy1 = b.y < p.y + p.h
  local hy2 = b.y + b.size > p.y
  if hx1 and hx2 and hy1 and hy2 then
    b.x = p.x + off
    b.dx = -b.dx
  end
end

function update_ball(dt)
  local b = S.ball
  move_ball(b, dt)
  bounce_walls(b)
  collide(b, S.player, S.player.w)
  collide(b, S.opp, -b.size)
end


-- scoring / reset --

function check_win()
  return S.playerScore >= WIN_SCORE or
         S.oppScore >= WIN_SCORE
end

function scored(side)
  if side == "opp" then
    S.oppScore = S.oppScore + 1
  else
    S.playerScore = S.playerScore + 1
  end
  rebuild_score_texts()
  if check_win() then
    S.state = "gameover"
    return true
  end
  return false
end

function check_score()
  local b = S.ball
  if b.x < 0 then
    return scored("opp")
  end
  if b.x + b.size > W() then
    return scored("plr")
  end
  return false
end

function ball_out()
  local b = S.ball
  return b.x < 0 or
         (b.x + b.size > W())
end

function reset_ball()
  local b = S.ball
  b.x = cx(BALL_SIZE)
  b.y = cy(BALL_SIZE)
  local s = S.playerScore + S.oppScore
  local dir = 1
  if s % 2 == 1 then
    dir = -1
  end
  b.dx = dir * BALL_SPEED_X
  local ymod = (s % 3 - 1) * BALL_SPEED_Y
  b.dy = ymod * 0.3
end


-- players --
function update_left(dt)
  local dir = 0
  if love.keyboard.isDown("q") then
    dir = -1
  elseif love.keyboard.isDown("a") then
    dir = 1
  end
  move_paddle(S.player, dir, dt)
end

function update_right(dt)
  local dir = 0
  if love.keyboard.isDown("up") then
    dir = -1
  elseif love.keyboard.isDown("down") then
    dir = 1
  end
  move_paddle(S.opp, dir, dt)
end


-- step and update

function step_game(dt)
  if S.state ~= "play" then return end
  local sdt = dt * SPEED_SCALE
  update_left(sdt)
  update_right(sdt)
  update_ball(sdt)
  if check_score() then return end
  if ball_out() then
    reset_ball()
  end
end

function update_fixed(rdt)
  ACC = ACC + rdt
  local steps = 0
  while ACC >= FIXED_DT and
        steps < MAX_STEPS do
    step_game(FIXED_DT)
    ACC = ACC - FIXED_DT
    steps = steps + 1
  end
end

function update_variable(rdt)
  step_game(rdt)
end

function love.update(dt)
  ensure_init()
  local now = love.timer.getTime()
  local rdt = now - TIME_T
  TIME_T = now
  if USE_FIXED then
    update_fixed(rdt)
  else
    update_variable(rdt)
  end
end


-- drawing --

function draw_bg()
  love.graphics.clear(COLOR_BG)
  love.graphics.setColor(COLOR_FG)
end

function draw_paddle(p)
  local x = math.floor(p.x + 0.5)
  local y = math.floor(p.y + 0.5)
  love.graphics.rectangle(
    "fill", x, y, p.w, p.h
  )
end

function draw_ball(b)
  local x = math.floor(b.x + 0.5)
  local y = math.floor(b.y + 0.5)
  love.graphics.rectangle(
    "fill", x, y, b.size, b.size
  )
end

function draw_scores()
  local lx = W() / 2 - 60
  local rx = W() / 2 + 40
  love.graphics.draw(
    TXT_L, lx, SCORE_OFFSET_Y
  )
  love.graphics.draw(
    TXT_R, rx, SCORE_OFFSET_Y
  )
end

function draw_controls()
  love.graphics.setColor(0.6, 0.6, 0.6)
  love.graphics.draw(
    TXT_HELP1, 20, H() - 40
  )
  love.graphics.draw(
    TXT_HELP2, 20, H() - 20
  )
  love.graphics.setColor(COLOR_FG)
end

function draw_start()
  local w = TXT_START:getWidth()
  local x = (W() - w) / 2
  local y = H() / 2 - 16
  love.graphics.draw(TXT_START, x, y)
end

function draw_gameover()
  local w = TXT_OVER:getWidth()
  local x = (W() - w) / 2
  local y = H() / 2 - 16
  love.graphics.draw(TXT_OVER, x, y)
end

function love.draw()
  ensure_init()
  draw_bg()
  love.graphics.draw(CENTER_CANVAS)
  draw_paddle(S.player)
  draw_paddle(S.opp)
  draw_ball(S.ball)
  draw_scores()
  draw_controls()
  if S.state == "start" then
    draw_start()
  end
  if S.state == "gameover" then
    draw_gameover()
  end
end

-- resize hook --

function love.resize()
  cache_wh()
  layout()
  build_center_canvas()
end
