require('utils.json')
require('utils.noobhub')


function love.update(dt)
    
end



function mobileStraight()  
    local wait=true
    while wait do
        love.window.maximize()
        love.window.setMode(600,650)
        local tx, ty = love.graphics.getDimensions()
        if ty>tx then wait=false end
    end
    local standard = 392 -- my phone's width
    screenw, screenh = love.graphics.getDimensions()
end