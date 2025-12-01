local Timer = require("timer")
local HUD = {}

function HUD.load()
    HUD.fontSmall = love.graphics.newFont(12)
    HUD.fontLarge = love.graphics.newFont(32)
end

function HUD.update(dt)
    Timer.update(dt)
end

function HUD.reset()
    Timer.reset()
end

-- internal: health bar (top-left)
local function drawHealthBar(player)
    local barWidth = 200
    local barHeight = 18
    local padding = 4

    local x = 20
    local y = 20

    local hpRatio = 0
    if player.maxHealth and player.maxHealth > 0 then
        hpRatio = math.max(0, player.health / player.maxHealth)
    end

    -- background panel (dark, slightly blueish)
    love.graphics.setColor(0.02, 0.06, 0.12, 0.9)
    love.graphics.rectangle("fill", x - 6, y - 6, barWidth + 12, barHeight + 18, 8, 8)

    -- outer border (neon cyan)
    love.graphics.setColor(0.0, 0.9, 1.0)
    love.graphics.rectangle("line", x - 6, y - 6, barWidth + 12, barHeight + 18, 8, 8)

    -- bar background
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", x, y, barWidth, barHeight, 4, 4)

    -- health fill (gradient-ish: lerp green → red)
    local r = 1 - hpRatio
    local g = hpRatio
    love.graphics.setColor(r * 0.8 + 0.2, g * 0.9 + 0.1, 0.2)

    love.graphics.rectangle("fill", x, y, barWidth * hpRatio, barHeight, 4, 4)

    -- text on top
    love.graphics.setFont(HUD.fontSmall)
    love.graphics.setColor(0.7, 1.0, 1.0)
    local hpText = string.format("HP %d / %d", player.health or 0, player.maxHealth or 0)
    love.graphics.print(hpText, x + padding, y + barHeight + 1)

    love.graphics.setColor(1, 1, 1, 1)
end

-- internal: score (top-center, big numeric)
local function drawScore(score)
    score = score or 0
    local scoreStr = string.format("%06d", score) -- zero-padded, arcade style

    love.graphics.setFont(HUD.fontLarge)
    local textW = love.graphics.getFont():getWidth(scoreStr)
    local textH = love.graphics.getFont():getHeight()

    local x = (WINDOW_WIDTH - textW) / 2
    local y = 15

    -- subtle glow panel behind
    love.graphics.setColor(0.02, 0.05, 0.1, 0.8)
    love.graphics.rectangle("fill", x - 20, y - 8, textW + 40, textH + 16, 10, 10)

    -- border
    love.graphics.setColor(0.0, 0.9, 1.0)
    love.graphics.rectangle("line", x - 20, y - 8, textW + 40, textH + 16, 10, 10)

    -- score text (bright cyan)
    love.graphics.setColor(0.6, 1.0, 1.0)
    love.graphics.print(scoreStr, x, y)

    love.graphics.setColor(1, 1, 1, 1)
end

-- internal: timer + difficulty (top-right)
local function drawTimerAndDifficulty()
    local elapsed = Timer.getTime()
    local difficulty = Timer.getDifficulty()

    local timeStr = string.format("T %5.1fs", elapsed)
    local diffStr = string.format("D x%.2f", difficulty)

    love.graphics.setFont(HUD.fontSmall)

    local padding = 8
    local lineHeight = 18
    local boxWidth = 160
    local boxHeight = 2 * lineHeight + padding * 2

    local x = WINDOW_WIDTH - boxWidth - 20
    local y = 20

    -- background
    love.graphics.setColor(0.02, 0.06, 0.12, 0.9)
    love.graphics.rectangle("fill", x, y, boxWidth, boxHeight, 8, 8)

    -- “techy” side accents
    love.graphics.setColor(0.0, 0.9, 1.0)
    love.graphics.rectangle("line", x, y, boxWidth, boxHeight, 8, 8)
    love.graphics.line(x + 10, y + boxHeight, x + 40, y + boxHeight + 6)
    love.graphics.line(x + boxWidth - 40, y + boxHeight + 6, x + boxWidth - 10, y + boxHeight)

    -- text
    love.graphics.setColor(0.6, 1.0, 1.0)
    love.graphics.print(timeStr, x + padding, y + padding)
    love.graphics.print(diffStr, x + padding, y + padding + lineHeight)

    love.graphics.setColor(1, 1, 1, 1)
end

function HUD.draw(player, score)
    drawHealthBar(player)
    drawScore(score)
    drawTimerAndDifficulty()
end

return HUD