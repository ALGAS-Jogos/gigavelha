require('utils.json')
require('utils.noobhub')
require('utils.draw')

math.randomseed(os.time(),os.time()-150)

hub = noobhub.new({server="187.73.30.41", port="15565"})
channel = math.random(10000,99999)
myTurn = true
inputchannel = ""
gameMessage = ""
menu = "start"

board = {}

redcolors = {}
redcolors[#redcolors+1] = {1, 0.851, 0}
redcolors[#redcolors+1] = {1, 0.459, 0}
redcolors[#redcolors+1] = {1, 0, 0.271}

bluecolors = {}
bluecolors[#bluecolors+1] = {0.29, 1, 0.659}
bluecolors[#bluecolors+1] = {0, 0.949, 1}
bluecolors[#bluecolors+1] = {0.29, 0.42, 1}

font = 32

team = 1 --1 for red 2 for blue
squaresAvailable = {}
squaresAvailable[#squaresAvailable+1] = 3
squaresAvailable[#squaresAvailable+1] = 3
squaresAvailable[#squaresAvailable+1] = 3
selectedSquare = 1

cursorBlink = 0.5
cursorBlinkMax = 0.5
cursorBlinkNow = false
unable = false
unableFn = function()end
dummyBoard = {}
dummyBoardReset = 5
dummyBoardResetMax = 5

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
    cursorBlink=cursorBlink-dt
    if cursorBlink<=0 then
        cursorBlink=cursorBlinkMax
        cursorBlinkNow=not cursorBlinkNow
    end
    dummyBoardReset=dummyBoardReset-dt
    if dummyBoardReset<=0 then
        resetDummyBoard()
        dummyBoardReset=dummyBoardResetMax
    end
end

function love.draw()
    if menu=="game" then
        drawGame()
    elseif menu=="start" or menu=="waitingmyown" or menu=="waitingqueue" or menu=="typenumber" then
        drawStartMenu()
    else
        drawEndMenu()
    end
end

function loadTable()
    for i=1,9 do
        board[i] = 0
    end
end

function love.mousepressed(mx,my)
    if menu=="end" then
        resetVars()
        return false
    end

    if myTurn==false or menu~="game" then return false end

    --bounds
    --x+w >= cx and x <= cx + cw and y+h >= cy and y <= cy + ch
    x = screenw/2-(wspacing*3)/2
    y = 50
    if mx >= x and mx <= x+wspacing*3 and my >= y and my <= y+hspacing*3 then
        if squaresAvailable[selectedSquare]<=0 then return false end
        boxNumber = tableBounds(mx,my)
        local squarePut = team+(2*selectedSquare-2)
        if squarePut>=board[boxNumber]+team then
            board[boxNumber] = squarePut
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
    if menu=="typenumber" then
        if tonumber(t) then
            inputchannel=inputchannel..t
            inputchannel=string.sub(inputchannel,1,5)
        end
    end
end

function love.keypressed(key)
    if menu~="game" then
        if key=="backspace" and menu=="typenumber" then
            inputchannel=string.sub(inputchannel,1,#inputchannel-1)
        end
        if key=="return" and menu=="typenumber" then
            enterGame(inputchannel)
            menu="game"
            myTurn=false
            team=2
        end
    end
end

function love.mousereleased()
    unable=false
    unableFn()
    unableFn=function()end
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
                if isOdd(board[a]) and isOdd(board[b]) and isOdd(board[c]) and board[a]>0 and board[b]>0 and board[c]>0 then
                   return t
                end
            else
                if not isOdd(board[a]) and not isOdd(board[b]) and not isOdd(board[c]) and board[a]>0 and board[b]>0 and board[c]>0 then
                    return t
                 end
            end
        end
    end

    for i = 1, 9 do
        if board[i]<=2 then
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
            print("RECEIVED: "..message.action)
            if message.action=="join" then
                menu="game"
            elseif message.action=="play" then
                local play = json.decode(message.content)
                board[play.play]=play.square
                myTurn=true
                winner = checkVictory()
                if winner=="draw" then
                    publish("draw","")
                    menu="end"
                    gameMessage="Empate!"
                elseif winner==1 or winner==2 then
                    publish("win",winner)
                    menu="end"
                    if winner==team then
                        gameMessage="Você venceu!"
                    else
                        gameMessage="Você perdeu! :("
                    end
                end
            elseif message.action=="draw" then
                menu="end"
                gameMessage="Empate!"
            elseif message.action=="win" then
                menu="end"
                if message.content==team then
                    gameMessage="Você venceu!"
                else
                    gameMessage="Você perdeu! :("
                end
            elseif message.action=="rematch" then
                menu="rematch"
            elseif message.action=="rematchaccept" then
                menu="game"
                resetVars()
                myTurn=false
                team=2
            end
        end
    })
    publish("join","")
end

function enterQueue(channel)
    hub:subscribe({
        channel = channel,
        callback = function(message)
            if message.action=="join" then
                publish("game",channel)
            end
            if message.action=="game" then
                publish("accept",message.content)
                enterGame(message.content)
                menu="game"
                myTurn=false
                team=2
            end
            if message.action=="accept" then
                if message.content==channel then
                    enterGame(channel)
                    menu="game"
                    myTurn=true
                    team=1
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
    channel=math.random(10000,99999)
    inputchannel=""
    loadTable()
    myTurn=true
    selectedSquare=1
    for i=1,3 do
        squaresAvailable[i]=3
    end
    team=1
end