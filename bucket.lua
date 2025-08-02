local bucket = {}
local cellsize = 32


function bucket.getKey(x, y)
    local x_bucket = math.floor(x / cellsize)
    local y_bucket = math.floor(y / cellsize)
    return x_bucket, y_bucket
end

return bucket
