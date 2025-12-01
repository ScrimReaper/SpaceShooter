local Timer = {}

local elapsed = 0

function Timer.update(dt)
    elapsed = elapsed + dt
end

function Timer.reset()
    elapsed = 0
end

function Timer.getTime()
    return elapsed
end

function Timer.getDifficulty()
    return 1 + elapsed / 60
end

function Timer.reset()
    elapsed = 0
end

return Timer
