local Bullet = require("bullet")
local Enemy = require("enemy")
local Player = require("player")
HC = require 'libs.HC'

function love.load()
    ship_image = love.graphics.newImage("assets/ship_128.png")
    enemy_image = love.graphics.newImage("assets/space_invader.png")

    WINDOW_HEIGHT = love.graphics.getHeight()
    WINDOW_WIDTH = love.graphics.getWidth()

    p_width = ship_image:getWidth()
    p_height = ship_image:getHeight()

    pX = (WINDOW_WIDTH - p_width) / 2
    pY = (WINDOW_HEIGHT - p_height) - 10

    player = Player.new(pX, pY, ship_image)

    p_speed = 300
    bullets = {}
    enemies = {}
    enemyGrid = {}
end

function love.update(dt)
    player:update(dt)
    updateBullets(dt)
    updateEnemies(dt)
    spawnEnemy(dt)
    detectCollisions()
end

function love.draw()
    player:draw()
    for _, b in ipairs(bullets) do
        Bullet.draw(b)
    end
    for _, e in ipairs(enemies) do
        Enemy.draw(e)
    end
end

function love.keypressed(key)
    if key == "space" then
        local b = player:shoot()
        if b then
            table.insert(bullets, b)
        end
    end
end

function updateBullets(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        Bullet.update(b, dt)

        local x, y, w, h = b:bbox()
        if y + h < 0 then
            table.remove(bullets, i)
        end
    end
end

function spawnEnemy(dt)
    local doSpawn = math.random() > 0.9
    if not doSpawn then
        return
    end

    local eX = (WINDOW_WIDTH - Enemy.width) * math.random()
    local newE = Enemy.new(eX, 0, enemy_image)
    table.insert(enemies, newE)
end

function updateEnemies(dt)
    for i = #enemies, 1, -1 do
        local e = enemies[i]

        e:update(dt)
        if e:getY() > WINDOW_HEIGHT then
            table.remove(enemies, i)
        end
    end
end
