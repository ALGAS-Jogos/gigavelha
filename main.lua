require('utils.json')
require('utils.noobhub')

local hub = noobhub.new({server="localhost", port="15565"})

local table = {}

local redcolors = {}
redcolors[#redcolors+1] = {1, 0.851, 0}
redcolors[#redcolors+1] = {1, 0.459, 0}
redcolors[#redcolors+1] = {1, 0, 0.271}

local bluecolors = {}
bluecolors[#bluecolors+1] = {0.29, 1, 0.659}
bluecolors[#bluecolors+1] = {0, 0.949, 1}
bluecolors[#bluecolors+1] = {0.29, 0.42, 1}

local font = 32

local team = 1 --1 for red 2 for blue
local squaresAvailable = {}
squaresAvailable[#squaresAvailable+1] = 3
squaresAvailable[#squaresAvailable+1] = 3
squaresAvailable[#squaresAvailable+1] = 3


local centerspacing = 100

function love.load()
    mobileStraight() --this game is meant to be an app only
    love.graphics.setBackgroundColor(0.2,0.2,0.2)
    loadTable()
end

function love.update(dt)
    
end

function love.draw()
    wspacing = (screenw-centerspacing)/3
    hspacing = (screenh-centerspacing*3)/3
    wspacing = math.min(wspacing,hspacing)
    hspacing = math.min(wspacing,hspacing)
    x = screenw/2-(wspacing*3)/2+wspacing
    y = 50
    for i=1,2 do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,10,hspacing*3)
        x=x+wspacing
    end
    x = screenw/2-(wspacing*3)/2
    y = 50+hspacing
    for i=1,2 do
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle('fill',x,y,wspacing*3,10)
        y=y+hspacing
    end

    for i=1,9 do --search for any obj
        local obj = table[i]
        bx = (i-1)%3+1 --block x
        by = math.floor((i-1)/3)+1 --block y
        if obj==1 then
            local size = 25
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[1])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==2 then
            local size = 25
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[1])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==3 then
            local size = 50
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[2])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==4 then
            local size = 50
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[2])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==5 then
            local size = 75
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(redcolors[3])
            love.graphics.rectangle('fill',x,y,size,size)
        elseif obj==6 then
            local size = 75
            x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))+(wspacing/2-size/2)+5
            y = 50+(hspacing*(by-1))+(hspacing/2-size/2)+5
            love.graphics.setColor(bluecolors[3])
            love.graphics.rectangle('fill',x,y,size,size)
        end
    end

    x=25
    y=screenh-screenh/4+25

    for i=1,3 do --draw squares
        local size = 25*i
        local spacing = 25*i+10
        if team==1 then
            love.graphics.setColor(redcolors[i])
        elseif team==2 then
            love.graphics.setColor(bluecolors[i])
        end
        love.graphics.rectangle('fill',x+(spacing/2-size/2),y+(75/2-size/2),size,size)
        love.graphics.setColor(1,1,1)
        love.graphics.printf(squaresAvailable[i],font,x,y+75,spacing,"center")
        x=x+spacing
    end

    love.graphics.setColor(1,1,1)
    love.graphics.printf("É seu turno!",font,0,y+15,screenw-50,"right")
end

function loadTable()
    for i=1,9 do
        table[i] = 0
    end
end


function mobileStraight()  
    local wait=true
    while wait do
        love.window.maximize()
        love.window.setMode(600,650)
        local tx, ty = love.graphics.getDimensions()
        if ty>tx then wait=false end
    end
    local standard = 650
    screenw, screenh = love.graphics.getDimensions()
    font = 40*(standard/screenw)
    font = love.graphics.newFont("Inter.ttf",font)
end