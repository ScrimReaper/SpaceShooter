local utils = require("utils")

local Enemy = {}
Enemy.__index=Enemy
Enemy.health = 100
Enemy.width = 15
Enemy.height = 15
local enemy_speed = 200

function Enemy.new(x,y,image)
    local self = setmetatable({}, Enemy)
    self.image=image

    self.x = x or 0
    self.y = y or 0

    self.w = 32
    self.h = 24
    self.speed = 200

    self.scaleX = self.w / image:getWidth()
    self.scaleY = self.h / image:getHeight()


    -- hitbox
    local cx = x + self.w/2
    local cy = y + self.h/2
    self.hitbox = HC.circle(cx, cy, 12)

    return self
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scaleX, self.scaleY)
end

function Enemy:update(dt)
    self.y = self.y + self.speed * dt

    local hx,hy = utils.calcHitboxPos(self)
    self.hitbox:moveTo(hx,hy)
end

function Enemy:getY()
    return self.y
end

function x_Move(e, jump)
    goLeft = math.random() > 0.5
    if goLeft then
        e.x = e.x - jump
    else
        e.x = e.x + jump
    end
end

function y_Move(e, jump)
    e.y = e.y + jump
end

return Enemy
