local Background = {}
Background.__index = Background


function Background.new(image)
    local self = setmetatable({}, Background)
    self.image = image
    self.scroll = 0
    self.speed = 50
    self.bg_h = image:getHeight()
    self.image:setFilter('nearest', 'nearest')
    return self
end

function Background:update(dt)
    self.scroll = self.scroll + self.speed * dt
    if self.scroll >= self.bg_h then
        self.scroll = self.scroll - self.bg_h
    end
end


function Background:draw()
    love.graphics.draw(self.image, 0, self.scroll - self.bg_h)
    love.graphics.draw(self.image, 0, self.scroll)
end

return Background