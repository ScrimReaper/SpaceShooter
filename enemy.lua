local Enemy = {}
Enemy.health = 100
Enemy.width = 15
Enemy.height = 15
local enemy_speed = 200

function Enemy.new(x)
    return { x = x, y = 0, dead = false }
end

function Enemy.draw(e)
    love.graphics.setColor(1, 0, 1)
    love.graphics.rectangle("fill", e.x, e.y, Enemy.width, Enemy.height)
    love.graphics.setColor(1, 1, 1)
end

function Enemy.update(e, dt)
    jump = enemy_speed * dt
    x_Move(e, jump)
    y_Move(e, jump)
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
