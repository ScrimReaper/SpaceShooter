local bullet = require("bullet")
local enemy =  require("enemy")


function love.load()
    player = love.graphics.newImage("ship_128.png")
    p_width = player:getWidth()
    p_height = player:getHeight()
    w_height = love.graphics.getHeight()
    w_width = love.graphics.getWidth()
    pX = (w_width - p_width)/2
    pY = (w_height - p_height)
    p_speed = 300
    bullets = {}
    enemies =  {}
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        pX = pX + p_speed * dt
    elseif love.keyboard.isDown("left") then
        pX = pX - p_speed * dt
    end
    updateBullets(dt)
    updateEnemies(dt)
    spawnEnemy(dt)

end


function love.draw()
        love.graphics.draw(player, pX ,pY )
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
    table.insert(bullets, bullet.new(pX+p_width/2, pY))
end


function updateBullets(dt)
    for i=#bullets, 1, -1 do
            local b = bullets[i]
            bullet.update(b, dt)
            if b.y < 0 then
                table.remove(bullets, i)
            end
    
        end

end

function spawnEnemy(dt)
    doSpawn = math.random()>0.9
    if not doSpawn then
        return
    end

    local eX = (w_width-enemy.width)*math.random()

    table.insert(enemies,enemy.new(eX))
end

function updateEnemies(dt)
    for i=#enemies ,1, -1 do
        local e = enemies[i]
        enemy.update(e, dt)
        if e.y < 0 then
            table.remove(enemies, i)
        end
    end
end