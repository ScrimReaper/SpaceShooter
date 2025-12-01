local HC = require "libs.HC"
local Bullet = require("bullet")
local utils = require("utils")
local Player = {}
Player.__index = Player

function Player.new(x, y, image)
    local self = setmetatable({}, Player)

    self.image = image
    self.w = image:getWidth()
    self.h = image:getHeight()

    self.x = x or 0
    self.y = y or 0
    self.speed = 300
    self.maxHealth = 100
    self.health = self.maxHealth

    local hX, hY = utils.calcHitboxPos(self)
    self.hitbox = HC.circle(hX, hY, 16)

    return self
end

function Player:update(dt)
    if love.keyboard.isDown("right") and (self.x + self.w) < WINDOW_WIDTH then
        local calcX = self.x + self.speed * dt
        local end_pos = WINDOW_WIDTH - self.w
        self.x = math.min(calcX, end_pos)
    elseif love.keyboard.isDown("left") then
        local calcX = self.x - self.speed * dt
        self.x = math.max(calcX, 0)
    end
    local hX, hY = utils.calcHitboxPos(self)
    self.hitbox:moveTo(hX, hY)
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Player:shoot()
    local cx, cy = self.hitbox:center()
    local bulletShape = Bullet.new(cx, self.y)
    return bulletShape
end

function Player:takeDamage(enemy)
    self.health = self.health - enemy.damage
    if self.health <= 0 then
        self.health = 0
        game_over = true
    end
end

return Player
