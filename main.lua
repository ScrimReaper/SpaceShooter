local bullet = require("bullet")
local enemy = require("enemy")
local bucket = require("bucket")

function love.load()
	player = love.graphics.newImage("ship_128.png")
	p_width = player:getWidth()
	p_height = player:getHeight()
	w_height = love.graphics.getHeight()
	w_width = love.graphics.getWidth()
	pX = (w_width - p_width) / 2
	pY = (w_height - p_height)
	p_speed = 300
	bullets = {}
	enemies = {}
	enemyGrid = {}
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
	detectCollisions()
end

function love.draw()
	love.graphics.draw(player, pX, pY)
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
  enemyGrid[x] = enemyGrid[x] or {} -- make sure map exists at x
  enemyGrid[x][y] = enemyGrid[x][y] or {} -- make sure map exists at x,y
  table.insert(enemyGrid[x][y], enemy)
end


function detectCollisions()
  local cx, cy = bucket.getKey(pX, pY)

  for dx = -1, 1 do
    for dy = -1, 1 do
      local bx, by = cx + dx, cy + dy
      local bucketRow = enemyGrid[bx]
      local bucket = bucketRow and bucketRow[by]

      if bucket then
        for _, e in ipairs(bucket) do
          if isColliding({ x = pX, y = pY }, e) then
            print("HIT at bucket", bx, by)
            -- Handle the collision
			e.dead=true

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
