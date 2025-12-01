local PopUps = {}

local damagePopups = {}

function PopUps.spawnDamagePopup(x, y, amount)
    table.insert(damagePopups, {
        x        = x,
        y        = y,
        text     = "-" .. amount,
        vy       = -60,      -- pixels/sec (upwards)
        age      = 0,
        lifetime = 0.6       -- seconds
    })
end

function PopUps.updateDamagePopups(dt)
    for i = #damagePopups, 1, -1 do
        local p = damagePopups[i]
        p.age = p.age + dt
        p.y   = p.y + p.vy * dt

        if p.age >= p.lifetime then
            table.remove(damagePopups, i)
        end
    end
end


function PopUps.drawDamagePopups()
    for _, p in ipairs(damagePopups) do
        local alpha = 1 - (p.age / p.lifetime)

        love.graphics.setColor(1, 0.2, 0.2, alpha) -- red, fading out
        love.graphics.print(p.text, p.x, p.y)
    end

    love.graphics.setColor(1, 1, 1, 1) -- reset
end

function PopUps.clearDamagePopups()
    damagePopups = {}
end

return PopUps