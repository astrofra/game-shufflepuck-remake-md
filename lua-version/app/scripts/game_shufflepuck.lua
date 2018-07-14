local unpack = unpack or table.unpack

function project3DTo2D(x, z, board_width, board_length)
  local top_left_x = 120
  local top_right_x = 320-120
  local top_y = 8
  local bottom_left_x = 0
  local bottom_right_x = 320
  local bottom_y = 130
  local norm_x = x/board_width+0.5
  local norm_y = z/board_length+0.5
  local persp_coef = {1/132.0, 5/132.0, 9/132.0, 13/132.0, 17/132.0, 22/132.0, 27/132.0, 34/132.0, 42/132.0, 51/132.0, 64/132.0, 80/132.0, 102/132.0, 132/132.0}
  norm_y = mapValueToArray(norm_y, 0.0, 1.0, persp_coef)
  local top_2d_x = (1.0-norm_x)*top_left_x+norm_x*top_right_x
  local bottom_2d_x = (1.0-norm_x)*bottom_left_x+norm_x*bottom_right_x
  local proj_2d_x = (1.0-norm_y)*top_2d_x+norm_y*bottom_2d_x
  local proj_2d_y = (1.0-norm_y)*top_y+norm_y*bottom_y
  local proj_scale = RangeAdjust(norm_y, 0.0, 1.0, 0.285, 1.0)
  return {proj_2d_x, proj_2d_y, proj_scale}
end

function gameReset()
  ball:reset()
  ball:setImpulse(10.0, 10.0)
end

function renderBall(ball_2d_x, ball_2d_y, ball_2d_scale)
  plus:Sprite2D(SCR_MARGIN_X+ball_2d_x, ball_2d_y-65*SCR_SCALE_FACTOR, 24*SCR_SCALE_FACTOR*ball_2d_scale, '@assets/game_ball.png')
end

function renderPlayer(player_2d_x, player_2d_y, player_2d_scale)
  plus:Sprite2D(SCR_MARGIN_X+player_2d_x, player_2d_y-65*SCR_SCALE_FACTOR, 64*SCR_SCALE_FACTOR*player_2d_scale, '@assets/game_racket.png')
end

function renderAI(ai_2d_x, ai_2d_y, ai_2d_scale)
  plus:Sprite2D(SCR_MARGIN_X+ai_2d_x, ai_2d_y-65*SCR_SCALE_FACTOR, 64*SCR_SCALE_FACTOR*ai_2d_scale, '@assets/game_racket.png')
end

function ballIsBehindRacket(ball, racket)
  if ball.pos_z < racket.pos_z then
    return true
  end
  return false
end

function gameMainLoop(dt)
  ball:update(dt)

  local mouse_x, mouse_y = plus:GetMousePos()
  player:setMouse(mouse_x/SCR_DISP_WIDTH, mouse_y/SCR_DISP_HEIGHT)
  player:update(dt)
  ai:updateGameData(ball.pos_x, ball.pos_z)
  ai:update(dt)

  if ball.velocity_z>0.0 then
    if  (not ballIsBehindRacket(ball, player)) and (BallWasWithinXReach(ball, player) or BallIsWithinXReach(ball, player)) then
      ball:setPosition(ball.pos_x, player.pos_z-ball.velocity_z*dt+math.min(0.0, player.velocity_z)*dt)
      player:setPosition(player.pos_x, ball.pos_z+player.length)
      ball:bounceZ()
    end
  end

  local ball_2d_x, ball_2d_y, ball_2d_scale = unpack(project3DTo2D(ball.pos_x, ball.pos_z, board.board_width, board.board_length))
  ball_2d_x = ball_2d_x*SCR_SCALE_FACTOR
  ball_2d_y = SCR_DISP_HEIGHT-ball_2d_y*SCR_SCALE_FACTOR

  local player_2d_x, player_2d_y, player_2d_scale = unpack(project3DTo2D(player.pos_x, player.pos_z, board.board_width, board.board_length))
  player_2d_x = player_2d_x*SCR_SCALE_FACTOR
  player_2d_y = SCR_DISP_HEIGHT-player_2d_y*SCR_SCALE_FACTOR

  local ai_2d_x, ai_2d_y, ai_2d_scale = unpack(project3DTo2D(ai.pos_x, ai.pos_z, board.board_width, board.board_length))
  ai_2d_x = ai_2d_x*SCR_SCALE_FACTOR
  ai_2d_y = SCR_DISP_HEIGHT-ai_2d_y*SCR_SCALE_FACTOR

  plus:SetBlend2D(hg.BlendAlpha)
  plus:Sprite2D(SCR_MARGIN_X+320*0.5*SCR_SCALE_FACTOR, (SCR_PHYSIC_HEIGHT-96*0.5)*SCR_SCALE_FACTOR, 106*SCR_SCALE_FACTOR, '@assets/robot5.png')
  plus:Image2D(SCR_MARGIN_X, 0, SCR_SCALE_FACTOR, '@assets/game_board.png')
  plus:Image2D(SCR_MARGIN_X, SCR_DISP_HEIGHT-32*SCR_SCALE_FACTOR, SCR_SCALE_FACTOR, '@assets/game_score_panel.png')
  renderAI(ai_2d_x, ai_2d_y, ai_2d_scale)

  if ball.pos_z-ball.radius<player.pos_z+player.length then
    renderBall(ball_2d_x, ball_2d_y, ball_2d_scale)
    renderPlayer(player_2d_x, player_2d_y, player_2d_scale)
  else
    renderPlayer(player_2d_x, player_2d_y, player_2d_scale)
    renderBall(ball_2d_x, ball_2d_y, ball_2d_scale)
  end

  plus:SetBlend2D(hg.BlendOpaque)
end

function BallIsWithinXReach(ball, racket)
  if ball.pos_x+ball.radius>racket.pos_x-racket.width*0.5 and ball.pos_x-ball.radius<racket.pos_x+racket.width*0.5 then
    return true
  end
  return false
end

function BallWasWithinXReach(ball, racket)
  if ball.prev_pos_x+ball.radius>racket.prev_pos_x-racket.width*0.5 and ball.prev_pos_x-ball.radius<racket.prev_pos_x+racket.width*0.5 then
    return true
  end
  return false
end