local Bullet = require("bullet")
local Enemy = require("enemy")
local Player = require("player")
local Timer = require("timer")
local Background = require("background")
local PopUp = require("popups")
local HUD = require("hud")
HC = require 'libs.HC'

function love.load()
    ship_image = love.graphics.newImage("assets/ship_128.png")
    enemy_image = love.graphics.newImage("assets/space_invader.png")
    bg_image = love.graphics.newImage("assets/bg.png")

    WINDOW_HEIGHT = love.graphics.getHeight()
    WINDOW_WIDTH = love.graphics.getWidth()

    p_width = ship_image:getWidth()
    p_height = ship_image:getHeight()

    pX = (WINDOW_WIDTH - p_width) / 2
    pY = (WINDOW_HEIGHT - p_height) - 10

    player = Player.new(pX, pY, ship_image)

    bg = Background.new(bg_image)

    p_speed = 300
    bullets = {}
    enemies = {}
    score = 0
    game_over = false
    HUD.load()
end

function love.update(dt)
    if game_over then
        return
    end

    HUD.update(dt)

    bg:update(dt)
    detectCollisions()
    player:update(dt)
    updateBullets(dt)
    updateEnemies(dt)
    spawnEnemy(dt)

    PopUp.updateDamagePopups(dt)
end

function love.draw()
    bg:draw()
    player:draw()
    for _, b in ipairs(bullets) do
        Bullet.draw(b)
    end
    for _, e in ipairs(enemies) do
        Enemy.draw(e)
    end

    PopUp.drawDamagePopups()
    HUD.draw(player, score)

    if game_over then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf(
                "GAME OVER\nScore: " .. score .. "\nPress R to restart",
                0, WINDOW_HEIGHT / 2 - 40,
                WINDOW_WIDTH, "center"
        )
        love.graphics.setColor(1, 1, 1)
    end
end

function love.keypressed(key)
    if game_over then
        if key == "r" then
            restartGame()
        end
        return
    end
    if key == "space" then
        local b = player:shoot()
        if b then
            table.insert(bullets, b)
        end
    end
end

function restartGame()
    bullets = {}
    enemies = {}
    score = 0

    PopUp.clearDamagePopups()

    HUD.reset()

    local pX = (WINDOW_WIDTH - ship_image:getWidth()) / 2
    local pY = (WINDOW_HEIGHT - ship_image:getHeight()) - 10
    player = Player.new(pX, pY, ship_image)

    game_over = false
end

function updateBullets(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        Bullet.update(b, dt)

        local x, y, w, h = b:bbox()
        if y + h < 0 then
            HC.remove(b)
            table.remove(bullets, i)
        end
    end
end

function spawnEnemy(dt)
    local difficulty = Timer.getDifficulty()-- 1.0, 1.5, 2.0, ...
    local baseChance = 0.96                      --
    local spawnThreshold = baseChance - 0.1 * (difficulty - 1)

    -- cap so it doesn't get insane
    spawnThreshold = math.max(0.5, spawnThreshold)

    local doSpawn = math.random() > spawnThreshold
    if not doSpawn then
        return
    end

    local eX = (WINDOW_WIDTH - Enemy.width) * math.random()
    local newE = Enemy.new(eX, 0, enemy_image)

    -- make this enemy faster based on difficulty
    newE.speed = newE.speed * difficulty

    table.insert(enemies, newE)
end

function updateEnemies(dt)
    for i = #enemies, 1, -1 do
        local e = enemies[i]
        if e.dead then
            table.remove(enemies, i)
        else

            e:update(dt)
            if e:getY() > WINDOW_HEIGHT then
                HC.remove(e.hitbox)
                table.remove(enemies, i)
            end
        end

    end
end

function detectCollisions()
    -- bullet vs others
    for bi = #bullets, 1, -1 do
        local b = bullets[bi]

        for otherShape, _ in pairs(HC.collisions(b)) do

            if otherShape.kind == "enemy" then
                local enemy = otherShape.owner
                if enemy then
                    enemy.dead = true
                    local px = enemy.x + enemy.w / 2
                    local py = enemy.y - 10
                    PopUp.spawnDamagePopup(px, py, player.damage)
                    HC.remove(enemy.hitbox)
                end

                score = score + 1

                HC.remove(b)
                table.remove(bullets, bi)
                -- remove bullet on hit
                break -- stop checking this bullet, it's gone
            end
        end
    end

    -- player vs others
    for otherShape, _ in pairs(HC.collisions(player.hitbox)) do
        if otherShape.kind == "enemy" then
            local enemy = otherShape.owner
            if enemy then
                enemy.dead = true
                HC.remove(enemy.hitbox)
            end
            player:takeDamage(enemy)
        end
    end
end



