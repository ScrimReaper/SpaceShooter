local Utils = {}

function Utils.calcHitboxPos(sprite)
    return sprite.x + sprite.w / 2, sprite.y + sprite.h / 2
end

return Utils