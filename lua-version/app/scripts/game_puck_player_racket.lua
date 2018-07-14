require('app/scripts/luaclass')

game_puck_player_racket = Class {
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
    self.pos_x = x
    self.pos_z = z
  end,

  reset = function(self)
    self.pos_x = self.initial_pox_x
    self.pos_z = self.initial_pox_z
    self.prev_pos_x = self.pos_x
    self.prev_pos_z = self.pos_z
  end,

  setMouse = function(self, x, y)
    x = Clamp(x, 0, 1.0)
    y = Clamp(y, 0, 0.5)
    self.target_pos_x = RangeAdjust(x, 0.0, 1.0, board.board_width*-0.5+self.width*0.5, board.board_width*0.5-self.width*0.5)
    self.target_pos_z = RangeAdjust(y, 0.0, 0.5, board.board_length*0.5-self.length*0.5, board.board_length*0.35-self.length*0.5)
  end,

  update = function(self, dt)
    self.prev_pos_x = self.pos_x
    self.prev_pos_z = self.pos_z
    self.pos_x = self.pos_x+(self.target_pos_x-self.pos_x)*dt*self.racket_speed
    self.pos_z = self.pos_z+(self.target_pos_z-self.pos_z)*dt*self.racket_speed
    self.velocity_x = self.pos_x-self.prev_pos_x
    self.velocity_z = self.pos_z-self.prev_pos_z
  end
}