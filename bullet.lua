local Bullet = {} --- this holds the functions like .new, .update, like statics in java
local bulletspeed = 400
Bullet.width = 4
Bullet.height = 10




function Bullet.new(x, y)
    return {x=x-Bullet.width/2,y=y}
    
end



function Bullet.update(b, dt)
b.y= b.y - bulletspeed * dt
    
end


function Bullet.draw(b)
    love.graphics.setColor(1,1,0)
    love.graphics.rectangle("fill",b.x,b.y,Bullet.width, Bullet.height )
    love.graphics.setColor(1,1,0)

    
end

return Bullet