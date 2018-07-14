require('app/scripts/luaclass')

game_puck_ai_racket = Class {
  max_racket_speed = 50,
  racket_speed = 50,
  velocity_x = 0.0,
  velocity_z = 0.0,
  initial_pox_x = 0.0,
  initial_pox_z = 0.0,
  pos_x = 0.0,
  pos_z = 0.0,
  target_pos_x = 0.0,
  target_pos_z = 0.0,
  prev_pos_x = 0.0,
  prev_pos_z = 0.0,
  width = 2.0,
  length = 0.5,

  setPosition = function(self, x, z)
    self.pos_x, self.pos_z = x, z
    self.target_pos_x, self.target_pos_z = x, z
  end,

  reset = function(self)
    self.pos_x = self.initial_pox_x
    self.pos_z = self.initial_pox_z
    self.prev_pos_x = self.pos_x
    self.prev_pos_z = self.pos_z
  end,

  updateGameData = function(self, ball_pos_x, ball_pos_z)
    self.target_pos_x = ball_pos_x
    self.target_pos_z = board.board_length*-0.5
    self.racket_speed = RangeAdjust(ball_pos_z, board.board_length*-0.5, board.board_length*-0.35, 0.0, 1.0)
    self.racket_speed = Clamp(self.racket_speed, 0.0, 1.0)
    self.racket_speed = RangeAdjust(self.racket_speed, 0.0, 1.0, self.max_racket_speed, self.max_racket_speed*0.01)
  end,

  update = function(self, dt)
    self.prev_pos_x = self.pos_x
    self.prev_pos_z = self.pos_z
    self.pos_x = self.pos_x+(self.target_pos_x-self.pos_x)*dt*self.racket_speed
    self.pos_z = self.pos_z+(self.target_pos_z-self.pos_z)*dt*self.max_racket_speed
    self.velocity_x = self.pos_x-self.prev_pos_x
    self.velocity_z = self.pos_z-self.prev_pos_z
  end
}
