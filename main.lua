require('utils.json')
require('utils.noobhub')

math.randomseed(os.time(),os.time()-150)

local ongame = false
local hub = noobhub.new({server="187.73.30.41", port="15565"})
local channel = math.random(10000,99999)
local myTurn = true
local inputchannel = ""
local onmychannel = false
local gameEnd,gameMessage = false, ""

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
local selectedSquare = 1


local centerspacing = 100

function love.load()
    mobileStraight() --this game is meant to be an app only
    love.graphics.setBackgroundColor(0.2,0.2,0.2)
    love.graphics.setLineWidth(5)
    wspacing = (screenw-centerspacing)/3
    hspacing = (screenh-centerspacing*3)/3
    wspacing = math.min(wspacing,hspacing)
    hspacing = math.min(wspacing,hspacing)
    loadTable()
end

function love.update(dt)
    hub:enterFrame()
end

function love.draw()
    if ongame and gameEnd==false then
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
            if selectedSquare==i then
                love.graphics.rectangle('line',x+(spacing/2-size/2),y+(75/2-size/2),size,size,5)
            end
            love.graphics.printf(squaresAvailable[i],font,x,y+75,spacing,"center")
            x=x+spacing
        end

        love.graphics.setColor(1,1,1)
        if myTurn then
            love.graphics.printf("É seu turno!",font,0,y+15,screenw-screenw/15,"right")
        else
            love.graphics.printf("Aguarde!",font,0,y+15,screenw-screenw/15,"right")
        end

    elseif gameEnd==false then
        y = 50
        love.graphics.printf("GigaVelha",font,0,y,screenw,"center")
        y=y+50
        love.graphics.printf("Toque em qualquer lugar da tela para usar o teclado",font,0,y,screenw,"center")
        y=y+150
        if onmychannel==false then
            love.graphics.printf("Digite o número da sala de alguém",font,0,y,screenw,"center")
            y=y+150
            love.graphics.printf("Sala: "..inputchannel,font,0,y,screenw,"center")
            y=y+150
            love.graphics.printf("Digite N para criar uma sala",font,0,y,screenw,"center")
        else
            love.graphics.printf("Sala: "..channel,font,0,y,screenw,"center")
            y=y+150
            love.graphics.printf("Esperando alguém entrar...",font,0,y,screenw,"center")
        end
    else
        y = 50
        love.graphics.printf("GigaVelha",font,0,y,screenw,"center")
        y=y+50
        love.graphics.printf("Toque em qualquer lugar da tela para voltar",font,0,y,screenw,"center")
        y=y+150
        love.graphics.printf(gameMessage,font,0,y,screenw,"center")
    end
end

function loadTable()
    for i=1,9 do
        table[i] = 0
    end
end

function love.mousepressed(mx,my)
    if ongame==false then
        love.keyboard.setTextInput(true)
        return false
    end
    if gameEnd then
        resetVars()
        return false
    end

    if myTurn==false then return false end

    --bounds
    --x+w >= cx and x <= cx + cw and y+h >= cy and y <= cy + ch
    x = screenw/2-(wspacing*3)/2
    y = 50
    if mx >= x and mx <= x+wspacing*3 and my >= y and my <= y+hspacing*3 then
        if squaresAvailable[selectedSquare]<=0 then return false end
        boxNumber = tableBounds(mx,my)
        local squarePut = team+(2*selectedSquare-2)
        if squarePut>=table[boxNumber]+team then
            table[boxNumber] = squarePut
            publish("play",json.encode({play=boxNumber,square=squarePut}))
            myTurn=false
            squaresAvailable[selectedSquare]=squaresAvailable[selectedSquare]-1 --take one
        end
    else
        x=25
        y=screenh-screenh/4+25
        for i=1,3 do
            local size = 25*i
            local spacing = 25*i+10
            local bx,by = x+(spacing/2-size/2), y+(75/2-size/2)
            if mx >= bx and mx <= bx+size and my >= by and my <= by+size then
                selectedSquare=i
            end
            x=x+spacing
        end
    end
end

function love.textinput(t)
    if ongame==false and onmychannel==false then
        if tonumber(t) then
            inputchannel=inputchannel..t
            inputchannel=string.sub(inputchannel,1,5)
        end
    end
end

function love.keypressed(key)
    if ongame==false then
        if key=="backspace" and onmychannel==false then
            inputchannel=string.sub(inputchannel,1,#inputchannel-1)
        end
        if key=="n" then
            onmychannel=true
            enterGame(channel)
        end
        if key=="return" then
            enterGame(inputchannel)
            ongame=true
            myTurn=false
            team=2
        end
    end
end

function tableBounds(mx,my)
    for i=1,9 do --figure which box
        bx = (i-1)%3+1 --block x
        by = math.floor((i-1)/3)+1 --block y
        x = screenw/2-(wspacing*3)/2+(wspacing*(bx-1))
        y = 50+(hspacing*(by-1))
        if mx >= x and mx <= x+wspacing and my >= y and my <= y+hspacing then
            return i
        end
    end
end

function checkVictory()
    local winningCombinations = {
        {1, 2, 3}, {4, 5, 6}, {7, 8, 9}, -- Rows
        {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, -- Columns
        {1, 5, 9}, {3, 5, 7}             -- Diagonals
    }

    for t=1,2 do
        for i, combination in ipairs(winningCombinations) do
            local a, b, c = combination[1], combination[2], combination[3]
            if t==1 then
                if isOdd(table[a]) and isOdd(table[b]) and isOdd(table[c]) and table[a]>0 and table[b]>0 and table[c]>0 then
                   return t
                end
            else
                if not isOdd(table[a]) and not isOdd(table[b]) and not isOdd(table[c]) and table[a]>0 and table[b]>0 and table[c]>0 then
                    return t
                 end
            end
        end
    end

    for i = 1, 9 do
        if table[i]<=2 then
            return nil -- Game is still ongoing
        end
    end

    return "draw"
end

function isOdd(n)
    if n%2==0 then return false end
    return true
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
    font = 40*(screenw/standard)
    font = love.graphics.newFont("Inter.ttf",font)
end


function enterGame(channel)
    hub:subscribe({
        channel = channel,
        callback = function(message)
            if message.action=="join" then
                ongame=true
            elseif message.action=="play" then
                local play = json.decode(message.content)
                table[play.play]=play.square
                myTurn=true
                winner = checkVictory()
                if winner=="draw" then
                    publish("draw","")
                    gameEnd=true
                    gameMessage="Empate!"
                    loadTable()
                elseif winner==1 or winner==2 then
                    publish("win",winner)
                    gameEnd=true
                    if winner==team then
                        gameMessage="Você venceu!"
                    else
                        gameMessage="Você perdeu! :("
                    end
                    loadTable()
                end
            elseif message.action=="draw" then
                gameEnd=true
                gameMessage="Empate!"
            elseif message.action=="win" then
                gameEnd=true
                print(team, message.content)
                if message.content==team then
                    gameMessage="Você venceu!"
                else
                    gameMessage="Você perdeu! :("
                end
            end
        end
    })
    publish("join","")
end

function publish(action,content)    
    hub:publish({
        message = {
            action = action,
            content = content,
            id = localId,
            name = localName,
            timestamp = os.time()
        }
    })
    print(action)
end

function resetVars()
    ongame=false
    channel=math.random(10000,99999)
    gameEnd=false
    onmychannel=false
    inputchannel=""
    loadTable()
    myTurn=true
    selectedSquare=1
    for i=1,3 do
        squaresAvailable[i]=3
    end
    team=1
end