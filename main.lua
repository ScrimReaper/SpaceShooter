
function love.load()
    player = love.graphics.newImage("ship_128.png")
    windowheigth = love.graphics.getHeight();
end

function love.draw()
        love.graphics.draw(player, 0 ,0  )
end