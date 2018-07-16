require('app/scripts/luaclass')

game_puck_ball_physics = Class {
  inertia = 0.1,
  velocity_x = 0.0,
  velocity_z = 0.0,
  initial_pox_x = 0.0,
  initial_pox_z = 0.0,
  pos_x = 0.0,
  pos_z = 0.0,
  prev_pos_x = 0.0,
  prev_pos_z = 0.0,
  radius = 0.5,

  reset = function(self)
    self.pos_x = self.initial_pox_x
    self.pos_z = self.initial_pox_z
    self.prev_pos_x = self.pos_x
    self.prev_pos_z = self.pos_z
    self.velocity_x = 0.0
    self.velocity_z = 0.0
  end,

  setImpulse = function(self, x, z)
    self.velocity_x = x
    self.velocity_z = z
  end,

  bounceX = function(self)
    self.velocity_x = self.velocity_x*-1
  end,

  bounceZ = function(self)
    self.velocity_z = self.velocity_z*-1
  end,

  setPosition = function(self, x, z)
    self.pos_x = x
    self.pos_z = z
  end,

  update = function(self, dt)
    self.prev_pos_x = self.pos_x
    self.prev_pos_z = self.pos_z
    self.pos_x = self.pos_x+self.velocity_x*dt
    self.pos_z = self.pos_z+self.velocity_z*dt

    if self.pos_x>board.board_width*0.5 then
      self.pos_x = board.board_width*0.5
      self:bounceX()
    elseif self.pos_x<board.board_width*-0.5 then
      self.pos_x = board.board_width*-0.5
      self:bounceX()
    end

    if self.pos_z<board.board_length*-0.5 then
      self.pos_z = board.board_length*-0.5
      self:bounceZ()
    end

    if self.pos_z>board.board_length*0.5 then
      self.pos_x = self.initial_pox_x
      self.pos_z = self.initial_pox_z
      self.prev_pos_x = self.pos_x
      self.prev_pos_z = self.pos_z
    end
  end
}
