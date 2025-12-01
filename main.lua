local Bullet = require("bullet")
local Enemy = require("enemy")
local bucket = require("bucket")
local Player = require("player")
HC = require 'libs.HC'


function love.load()
    ship_image = love.graphics.newImage("assets/ship_128.png")

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
    local newE = Enemy.new(eX)
    table.insert(enemies, newE)
    addToGrid(newE)
end

function updateEnemies(dt)
    enemyGrid = {}
    for i = #enemies, 1, -1 do
        local e = enemies[i]
        Enemy.update(e, dt)
        if e.y < 0 or e.dead then
            table.remove(enemies, i)
        else
            addToGrid(e)
        end
    end
end

function addToGrid(enemy)
    local x, y = bucket.getKey(enemy.x, enemy.y)
    enemyGrid[x] = enemyGrid[x] or {}    -- make sure map exists at x
    enemyGrid[x][y] = enemyGrid[x][y] or {} -- make sure map exists at x,y
    table.insert(enemyGrid[x][y], enemy)
end

function detectCollisions()
    local cx, cy = bucket.getKey(pX, pY)

    for dx = -2, 2 do
        for dy = -2, 2 do
            local bx, by = cx + dx, cy + dy
            local bucketRow = enemyGrid[bx]
            local bucket = bucketRow and bucketRow[by]

            if bucket then
                for _, e in ipairs(bucket) do
                    if isColliding({ x = pX, y = pY }, e) then
                        print("HIT at bucket", bx, by)
                        -- Handle the collision
                        e.dead = true
                    end
                end
            end
        end
    end
end

function isColliding(a, e)
    return a.x < e.x + Enemy.width and
            a.x + p_width > e.x and
            a.y < e.y + Enemy.height and
            a.y + p_height > e.y
end
