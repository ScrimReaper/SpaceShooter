local Utils = {}

function Utils.calcHitboxPos(sprite)
    return sprite.x + sprite.w / 2, sprite.y + sprite.h / 2
end

function Utils.drawHealthBar(player)
        local barWidth = 200
        local barHeight = 20
        local x, y = 20, 20

        local hpRatio = math.max(0, player.health / player.maxHealth)

        -- background
        love.graphics.setColor(0.2, 0.2, 0.2)  -- dark gray
        love.graphics.rectangle("fill", x, y, barWidth, barHeight)

        -- health part (green)
        love.graphics.setColor(0.2, 0.8, 0.2)
        love.graphics.rectangle("fill", x, y, barWidth * hpRatio, barHeight)

        -- border
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", x, y, barWidth, barHeight)

        -- text
        love.graphics.print("HP: " .. math.floor(player.health), x + 5, y + 2)

        -- reset color
        love.graphics.setColor(1, 1, 1)
    end
function Utils.drawScore(score)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 20, 50)

end

return Utils