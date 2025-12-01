local bullet = require("bullet")
local enemy = require("enemy")
local bucket = require("bucket")
HC = require 'libs.HC'

local p_height = 80
local p_width = 128

function love.load()
    ship_image = love.graphics.newImage("assets/ship_128.png")

    w_height = love.graphics.getHeight()
    w_width = love.graphics.getWidth()

    p_width = ship_image:getWidth()
    p_height = ship_image:getHeight()

    pX = (w_width - p_width) / 2
    pY = (w_height - p_height) - 10

    player = HC.circle(pX + p_width / 2, pY + p_height / 2, 16)

    p_speed = 300
    bullets = {}
    enemies = {}
    enemyGrid = {}
end

function love.update(dt)
    if love.keyboard.isDown("right") and (pX + p_width) < w_width then
        local calcXR = pX + p_speed * dt
        local endpos = w_width - p_width
        pX = calcXR < (endpos) and calcXR or endpos
    elseif love.keyboard.isDown("left") and pX > 0 then
        local calcXL = pX - p_speed * dt
        pX = calcXL > 0 and calcXL or 0
    end
    updateBullets(dt)
    updateEnemies(dt)
    spawnEnemy(dt)
    detectCollisions()
end

function love.draw()
    love.graphics.draw(ship_image, pX, pY)
    for _, b in ipairs(bullets) do
        bullet.draw(b)
    end
    for _, e in ipairs(enemies) do
        enemy.draw(e)
    end
end

function love.keypressed(key)
    if key == "space" then
        shootBullet()
    end
end

function shootBullet()
    table.insert(bullets, bullet.new(pX + p_width / 2, pY))
end

function updateBullets(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        bullet.update(b, dt)
        if b.y < 0 then
            table.remove(bullets, i)
        end
    end
end

function spawnEnemy(dt)
    local doSpawn = math.random() > 0.9
    if not doSpawn then
        return
    end

    local eX = (w_width - enemy.width) * math.random()
    local newE = enemy.new(eX)
    table.insert(enemies, newE)
    addToGrid(newE)
end

function updateEnemies(dt)
    enemyGrid = {}
    for i = #enemies, 1, -1 do
        local e = enemies[i]
        enemy.update(e, dt)
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
    return a.x < e.x + enemy.width and
            a.x + p_width > e.x and
            a.y < e.y + enemy.height and
            a.y + p_height > e.y
end
