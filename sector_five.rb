require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'

class SectorFive < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  ENEMY_FREQUENCY = 0.05
  
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Sector Five'
    @player = Player.new(self)
    @enemies = []
    @bullets = []
    @explosions = []
  end

  def draw
    @player.draw
    @enemies.each { |enemy| enemy.draw }
    @bullets.each { |bullet| bullet.draw }
    @explosions.each { |explosion| explosion.draw }
  end

  def update
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
    if rand < ENEMY_FREQUENCY
      @enemies.push Enemy.new(self)
    end
    @enemies.each { |enemy| enemy.move }
    @bullets.each { |bullet| bullet.move }
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        if distance < enemy.radius + bullet.radius
          @enemies.delete enemy
          @bullets.delete bullet
          @explosions.push Explosion.new(self, enemy.x, enemy.y)
        end
      end
    end
    @explosions.reject! { |explosion| explosion.finished? }
    @enemies.reject! { |enemy| enemy.y > HEIGHT + enemy.radius }
    @bullets.reject! { |bullet| !bullet.onscreen? }
  end

  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end
  end
end

window = SectorFive.new
window.show
