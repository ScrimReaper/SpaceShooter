local Bullet = {} --- this holds the functions like .new, .update, like statics in java
local bulletspeed = 400
Bullet.width = 4
Bullet.height = 10

function Bullet.new(x, y)
    local bX = x - Bullet.width / 2
    local bY = y - Bullet.height / 2
    local rect = HC.rectangle(bX, bY, Bullet.width, Bullet.height)
    rect.kind = "bullet"
    return rect
end

function Bullet.update(b, dt)
    local dY = -dt * bulletspeed   -- negative = move up
    b:move(0, dY)
end

function Bullet.draw(b)
    b:draw('fill')
end

return Bullet
