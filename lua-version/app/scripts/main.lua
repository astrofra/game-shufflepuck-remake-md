hg = require('harfang')
require('app/scripts/utils')
require('app/scripts/basic_vector')

board = require('app/scripts/game_puck_board')

require('app/scripts/game_puck_ball_physics')
require('app/scripts/game_puck_player_racket')
require('app/scripts/game_puck_ai_racket')
require('app/scripts/game_shufflepuck')

ball = game_puck_ball_physics()
player = game_puck_player_racket()
ai = game_puck_ai_racket()

SCR_PHYSIC_WIDTH = 320
SCR_PHYSIC_HEIGHT = 200
SCR_DISP_WIDTH = 320*2
SCR_DISP_HEIGHT = 200*2
SCR_SCALE_FACTOR = math.min(SCR_DISP_WIDTH/SCR_PHYSIC_WIDTH, SCR_DISP_HEIGHT/SCR_PHYSIC_HEIGHT)
SCR_MARGIN_X = (SCR_DISP_WIDTH-SCR_PHYSIC_WIDTH*SCR_SCALE_FACTOR)/2.0

hg.LoadPlugins()
plus = hg.GetPlus()

plus:RenderInit(SCR_DISP_WIDTH, SCR_DISP_HEIGHT, 4, hg.Windowed)
hg.MountFileDriver(hg.StdFileDriver('app/assets/'), '@assets/')

gameReset()

player.initial_pox_z = board.board_length*0.45
player:reset()

while not plus:IsAppEnded() do
  plus:Clear()
  local dt = hg.time_to_sec_f(plus:UpdateClock())
  gameMainLoop(dt)
  plus:Flip()
  plus:EndFrame()
end
